resource "aws_alb" "ecs" {
  name            = "${var.ecs_cluster_name}-${var.environment}"
  security_groups = ["${var.security_group_alb_id}"]
  subnets         = ["${var.vpc_subnets}"]
  tags            = "${var.tags}"
}

resource "aws_alb_target_group" "ecs-green" {
  depends_on = ["aws_alb.ecs"]

  name        = "${var.ecs_cluster_name}-${var.environment}-green"
  port        = "80"
  protocol    = "HTTP"
  target_type = "${var.target_type}"
  vpc_id      = "${var.vpc_id}"

  deregistration_delay = 180

  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    path                = "${var.health_path}"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }

  tags = "${var.tags}"
}

resource "aws_alb_target_group" "ecs-blue" {
  depends_on = ["aws_alb.ecs"]

  name        = "${var.ecs_cluster_name}-${var.environment}-blue"
  port        = "80"
  protocol    = "HTTP"
  target_type = "${var.target_type}"
  vpc_id      = "${var.vpc_id}"

  deregistration_delay = 180

  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    path                = "${var.health_path}"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }

  tags = "${var.tags}"
}

resource "aws_alb_listener" "ecs" {
  load_balancer_arn = "${aws_alb.ecs.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.ecs-green.arn}"
    type             = "forward"
  }
}
