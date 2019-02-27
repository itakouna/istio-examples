data "aws_availability_zones" "available" {}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.name}-${var.environment}"
  cidr = "${var.cidr}"

  azs = "${data.aws_availability_zones.available.names}"

  private_subnets = [
    "${lookup(var.private_subnets, "eu-central-1a")}",
    "${lookup(var.private_subnets, "eu-central-1b")}",
    "${lookup(var.private_subnets, "eu-central-1c")}",
  ]

  public_subnets = [
    "${lookup(var.public_subnets, "eu-central-1a")}",
    "${lookup(var.public_subnets, "eu-central-1b")}",
    "${lookup(var.public_subnets, "eu-central-1c")}",
  ]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

###aws_security_group####
resource "aws_security_group" "alb" {
  name        = "${var.name}-${var.environment}"
  description = "Security Group managed by Terraform"
  vpc_id      = "${module.vpc.vpc_id}"
  tags        = "${merge(var.tags, map("Name", format("%s-alb", var.name)))}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "instance" {
  name        = "${var.name}-${var.environment}-instance"
  description = "Security Group managed by Terraform"
  vpc_id      = "${module.vpc.vpc_id}"
  tags        = "${merge(var.tags, map("Name", format("%s-instance", var.name)))}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "instance_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.instance.id}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "instance_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.instance.id}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "alb_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.alb.id}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "instance_inbound_from_alb" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.alb.id}"
  security_group_id        = "${aws_security_group.instance.id}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.alb.id}"

  lifecycle {
    create_before_destroy = true
  }
}
