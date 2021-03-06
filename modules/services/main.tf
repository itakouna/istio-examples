data "aws_ecs_task_definition" "task_awsvpc_data" {
  count = "${var.network_mode == "awsvpc" ? 1 : 0 }"

  depends_on      = ["aws_ecs_task_definition.task_awsvpc"]
  task_definition = "${aws_ecs_task_definition.task_awsvpc.family}"
}

data "aws_ecs_task_definition" "task_bridge_data" {
  count = "${var.network_mode == "awsvpc" ? 0 : 1 }"

  depends_on      = ["aws_ecs_task_definition.task_bridge"]
  task_definition = "${aws_ecs_task_definition.task_bridge.family}"
}

resource "aws_ecs_task_definition" "task_awsvpc" {
  count                    = "${var.network_mode == "awsvpc" ? 1 : 0 }"
  family                   = "${var.service_name}"
  container_definitions    = "${var.container_definitions}"
  network_mode             = "${var.network_mode}"
  requires_compatibilities = ["${var.compatibilities}"]
  tags                     = "${var.tags}"
}

resource "aws_ecs_task_definition" "task_bridge" {
  count                 = "${var.network_mode == "awsvpc" ? 0 : 1 }"
  family                = "${var.service_name}"
  container_definitions = "${var.container_definitions}"
  tags                  = "${var.tags}"
}

resource "aws_ecs_service" "service_bridge" {
  count               = "${var.network_mode == "awsvpc" ? 0 : 1 }"
  name                = "${var.service_name}"
  iam_role            = "${var.iam_service_role}"
  cluster             = "${var.ecs_cluster_id}"
  scheduling_strategy = "${var.scheduling_strategy}"
  task_definition     = "${aws_ecs_task_definition.task_bridge.family}:${max("${aws_ecs_task_definition.task_bridge.revision}", "${data.aws_ecs_task_definition.task_bridge_data.revision}")}"
  desired_count       = "${var.desired_task_count}"

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  load_balancer {
    target_group_arn = "${var.alb_target_group_arn}"
    container_port   = "${var.service_port}"
    container_name   = "${var.service_name}"
  }

  tags = "${var.tags}"
}

resource "aws_ecs_service" "service_awsvpc" {
  count           = "${var.network_mode == "awsvpc" ? 1 : 0 }"
  name            = "${var.service_name}"
  cluster         = "${var.ecs_cluster_id}"
  task_definition = "${aws_ecs_task_definition.task_awsvpc.family}:${max("${aws_ecs_task_definition.task_awsvpc.revision}", "${data.aws_ecs_task_definition.task_awsvpc_data.revision}")}"
  desired_count   = "${var.desired_task_count}"

  network_configuration {
    security_groups = ["${var.security_group_instance_id}"]
    subnets         = ["${var.vpc_subnets}"]
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  load_balancer {
    target_group_arn = "${var.alb_target_group_arn}"
    container_port   = "${var.service_port}"
    container_name   = "${var.service_name}"
  }

  tags = "${var.tags}"
}
