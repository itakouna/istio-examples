resource "aws_alb" "ecs" {
  name            = "${var.name}-load-balancer"
  security_groups = ["${aws_security_group.alb.id}"]
  subnets         = ["${module.vpc.vpc_subnets}"]
}

resource "aws_alb_target_group" "ecs" {
  depends_on = ["aws_alb.ecs"]

  name     = "${var.name}-target-group"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = "${module.vpc.vpc_id}"

  deregistration_delay = 180

  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }
}

resource "aws_alb_listener" "ecs" {
  load_balancer_arn = "${aws_alb.ecs.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.ecs.arn}"
    type             = "forward"
  }
}
