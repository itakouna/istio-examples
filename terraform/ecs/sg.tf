resource "aws_security_group" "ecs" {
  name        = "${var.name}-container-instance"
  description = "Security Group managed by Terraform"
  vpc_id      = "${module.vpc.vpc_id}"
  tags        = "${merge(var.tags, map("Name", format("%s-container-instance", var.name)))}"
lifecycle {
        create_before_destroy = true
    }

}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.ecs.id}"

  lifecycle {
        create_before_destroy = true
    }

}

resource "aws_security_group_rule" "ecs" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.ecs.id}"

  lifecycle {
        create_before_destroy = true
    }

}
