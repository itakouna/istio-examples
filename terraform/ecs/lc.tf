data "template_file" "user_data" {
  template = "${file("${path.module}/template/user-data.tpl")}"

  vars = {
    ecs_cluster = "${var.name}"
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
  key_name   = "${var.name}"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "aws_launch_configuration" "instance" {
  name_prefix          = "${var.name}-lc"
  image_id             = "${data.aws_ami.ecs.id}"
  instance_type        = "${var.instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.instance.name}"
  security_groups      = ["${aws_security_group.ecs.id}"]
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
