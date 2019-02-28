data "aws_ecs_task_definition" "task_data" {
  depends_on      = ["aws_ecs_task_definition.task"]
  task_definition = "${aws_ecs_task_definition.task.family}"
}

resource "aws_ecs_task_definition" "task" {
  family                = "${var.service_name}"
  container_definitions = "${var.container_definitions}"
}

resource "aws_ecs_service" "service" {
  name            = "${var.ecs_cluster_name}-${var.service_name}"
  iam_role        = "${var.iam_service_role}"
  cluster         = "${var.ecs_cluster_id}"
  task_definition = "${aws_ecs_task_definition.task.family}:${max("${aws_ecs_task_definition.task.revision}", "${data.aws_ecs_task_definition.task_data.revision}")}"
  desired_count   = 2

  load_balancer {
    target_group_arn = "${var.alb_target_group_arn}"
    container_port   = "${var.service_port}"
    container_name   = "${var.service_name}"
  }
}
