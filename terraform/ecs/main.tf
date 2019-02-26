module "vpc" {
  source = "../vpc"
}

data "template_file" "user_data" {
  template = "${file("${path.module}/template/user-data.tpl")}"

  vars = {
    ecs_cluster = "${var.name}"
  }
}

resource "aws_ecs_cluster" "ecs" {
  name = "${var.name}"
}

resource "aws_iam_role" "instance" {
  name = "${var.name}-instance-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_policy" {
  role       = "${aws_iam_role.instance.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "instance" {
  name = "${var.name}-instance-profile"
  role = "${aws_iam_role.instance.name}"
}

resource "aws_security_group" "instance" {
  name        = "${var.name}-container-instance"
  description = "Security Group managed by Terraform"
  vpc_id      = "${module.vpc.vpc_id}"
  tags        = "${merge(var.tags, map("Name", format("%s-container-instance", var.name)))}"
}

resource "aws_security_group_rule" "instance_out_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.instance.id}"
}

data "aws_ami" "ecs" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

resource "aws_key_pair" "user" {
  count      = "${var.instance_keypair != "" ? 0 : 1}"
  key_name   = "${var.name}"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "aws_launch_configuration" "instance" {
  name_prefix          = "${var.name}-lc"
  image_id             = "${data.aws_ami.ecs.id}"
  instance_type        = "${var.instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.instance.name}"
  security_groups      = ["${aws_security_group.instance.id}"]
  key_name             = "${var.instance_keypair != "" ? var.instance_keypair : element(concat(aws_key_pair.user.*.key_name, list("")), 0)}"
  user_data            = "${data.template_file.user_data.rendered}"

  root_block_device {
    volume_size = "${var.instance_root_volume_size}"
    volume_type = "gp2"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name = "${var.name}-asg"

  launch_configuration = "${aws_launch_configuration.instance.name}"
  vpc_zone_identifier  = ["${module.vpc.vpc_subnets}"]
  max_size             = "${var.asg_max_size}"
  min_size             = "${var.asg_min_size}"
  desired_capacity     = "${var.asg_desired_size}"

  health_check_grace_period = 300
  health_check_type         = "EC2"

  lifecycle {
    create_before_destroy = true
  }
}
