resource "aws_iam_role" "codedeploy" {
  name = "${var.cluster_name}-codedeploy-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "codedeploy" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
  role       = "${aws_iam_role.codedeploy.name}"
}

resource "aws_codedeploy_app" "service" {
  compute_platform = "ECS"
  name             = "${var.service_name}"
}

resource "aws_codedeploy_deployment_group" "service" {
  app_name               = "${aws_codedeploy_app.service.name}"
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = "${var.service_name}"
  service_role_arn       = "${aws_iam_role.codedeploy.arn}"

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }


  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = "${var.cluster_name}"
    service_name = "${var.service_name}"
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = ["${var.alb_listener_arn}"]
      }

      target_group {
        name = "${var.alb_target_group_name_ecs_green}"
      }

      target_group {
        name = "${var.alb_target_group_name_ecs_blue}"
      }
    }
  }
}

resource "aws_codedeploy_deployment_config" "service" {
  deployment_config_name = "${var.cluster_name}-deployment_config"

  minimum_healthy_hosts {
    type  = "HOST_COUNT"
    value = 2
  }
}

