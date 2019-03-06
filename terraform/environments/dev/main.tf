locals {
  bookings = {
    service_name       = "bookings"
    service_port       = "8080"
    tasks_definitions  = "tasks-definitions/bookings.json"
    desired_task_count = 1
  }


  service_name     = "bookings"
  ecs_cluster_name = "takouna"
  environment      = "dev"
  target_type      = "ip"
  network_mode     = "awsvpc"
  compatibilities  = "EC2"
  health_path      = "/health"
}

module "dev-vcp" {
  source      = "../../modules/vpc"
  name        = "${local.ecs_cluster_name}"
  environment = "${local.environment}"

  tags = {
    Name = "${local.ecs_cluster_name}-${local.environment}"
  }
}

module "dev-ecs" {
  source                     = "../../modules/ecs"
  ecs_cluster_name           = "${local.ecs_cluster_name}"
  vpc_id                     = "${module.dev-vcp.vpc_id}"
  environment                = "${local.environment}"
  vpc_subnets                = "${module.dev-vcp.vpc_subnets}"
  security_group_instance_id = "${module.dev-vcp.security_group_instance_id}"
  security_group_alb_id      = "${module.dev-vcp.security_group_alb_id}"
  target_type                = "${local.target_type}"
  health_path                = "${local.health_path}"
}

module "dev-bookings" {
  source                     = "../../modules/services"
  network_mode               = "${local.network_mode}"
  vpc_id                     = "${module.dev-vcp.vpc_id}"
  environment                = "${local.environment}"
  service_name               = "${local.bookings["service_name"]}"
  service_port               = "${local.bookings["service_port"]}"
  desired_task_count         = "${local.bookings["desired_task_count"]}"
  iam_service_role           = "${module.dev-ecs.iam_service_role}"
  ecs_cluster_id             = "${module.dev-ecs.ecs_cluster_id}"
  ecs_cluster_name           = "${module.dev-ecs.ecs_cluster_name}"
  container_definitions      = "${file("${local.bookings["tasks_definitions"]}")}"
  alb_target_group_arn       = "${module.dev-ecs.alb_target_group_arn_ecs_green}"
  security_group_instance_id = "${module.dev-vcp.security_group_instance_id}"
  vpc_subnets                = "${module.dev-vcp.vpc_subnets}"
  compatibilities            = "${local.compatibilities}"
}

module "dev-codedeploy" {
  source       = "../../modules/codedeploy"
  cluster_name = "${module.dev-ecs.ecs_cluster_name}"
  service_name = "${local.bookings["service_name"]}"
  alb_target_group_name_ecs_green = "${module.dev-ecs.alb_target_group_name_ecs_green}"
  alb_target_group_name_ecs_blue  = "${module.dev-ecs.alb_target_group_name_ecs_blue}"
  alb_listener_arn               = "${module.dev-ecs.alb_listener_arn}"
}
