resource "aws_ecs_service" "bookings" {
  name            = "${var.name}-bookings"
  iam_role        = "${aws_iam_role.service.name}"
  cluster         = "${aws_ecs_cluster.ecs.id}"
  task_definition = "${aws_ecs_task_definition.bookings.family}:${max("${aws_ecs_task_definition.bookings.revision}", "${data.aws_ecs_task_definition.bookings.revision}")}"
  desired_count   = 2

  load_balancer {
    target_group_arn = "${aws_alb_target_group.ecs.arn}"
    container_port   = 5003
    container_name   = "bookings"
  }
}
