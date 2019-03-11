locals {
  service_name      = "bookings"
  service_port      = "8080"
  tasks_definitions = "tasks-definitions/bookings.json"
  desired_task_count = 1
  environment       = "dev"
  compatibilities   = "EC2"
}

module "bookings" {
  source                     = "../../../../modules/services"
  network_mode               = "${local.network_mode}"
  vpc_id                     = "${data.terraform_remote_state.ecs.vpc_id}"
  environment                = "${local.environment}"
  service_name               = "${local.service_name}"
  service_port               = "${local.service_port}"
  desired_task_count         = "${local.desired_task_count}"
  iam_service_role           = "${data.terraform_remote_state.ecs.iam_service_role}"
  ecs_cluster_id             = "${data.terraform_remote_state.ecs.ecs_cluster_id}"
  ecs_cluster_name           = "${data.terraform_remote_state.ecs.ecs_cluster_name}"
  container_definitions      = "${file("${local.tasks_definitions}")}"
  alb_target_group_arn       = "${data.terraform_remote_state.ecs.alb_target_group_arn_ecs_green}"
  security_group_instance_id = "${data.terraform_remote_state.ecs.security_group_instance_id}"
  vpc_subnets                = "${data.terraform_remote_state.ecs.vpc_subnets}"
  compatibilities            = "${local.compatibilities}"
}

module "codedeploy" {
  source       = "../../../../modules/codedeploy"
  cluster_name = "${data.terraform_remote_state.ecs.ecs_cluster_name}"
  service_name = "${local.service_name}"
  alb_target_group_name_ecs_green = "${data.terraform_remote_state.ecs.alb_target_group_name_ecs_green}"
  alb_target_group_name_ecs_blue  = "${data.terraform_remote_state.ecs.alb_target_group_name_ecs_blue}"
  alb_listener_arn               = "${data.terraform_remote_state.ecs.alb_listener_arn}"
}
