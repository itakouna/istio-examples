resource "aws_autoscaling_group" "ecs" {
  name = "${var.ecs_cluster_name}-${var.environment}"

  launch_configuration = "${aws_launch_configuration.instance.name}"
  vpc_zone_identifier  = ["${var.vpc_subnets}"]
  max_size             = "${var.asg_max_size}"
  min_size             = "${var.asg_min_size}"
  desired_capacity     = "${var.asg_desired_size}"

  health_check_grace_period = 300
  health_check_type         = "ELB"

  tag {
    key                 = "Name"
    value               = "${var.ecs_cluster_name}-${var.environment}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

###### aws_launch_configuration######
data "template_file" "user_data" {
  template = "${file("${path.module}/template/user-data.tpl")}"

  vars = {
    ecs_cluster = "${var.ecs_cluster_name}-${var.environment}"
  }
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
  key_name   = "${var.ecs_cluster_name}-${var.environment}"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "aws_launch_configuration" "instance" {
  name_prefix          = "${var.ecs_cluster_name}-${var.environment}"
  image_id             = "${data.aws_ami.ecs.id}"
  instance_type        = "${var.instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.instance.name}"
  security_groups      = ["${var.security_group_instance_id}"]
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
