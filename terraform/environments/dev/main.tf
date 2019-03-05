locals {
  bookings-v1 = {
    service_name       = "bookings-v1"
    service_port       = "5003"
    tasks_definitions  = "tasks-definitions/bookings-v1.json"
    desired_task_count = 1
  }

  bookings-v2 = {
    service_name       = "bookings-v2"
    service_port       = "5003"
    tasks_definitions  = "tasks-definitions/bookings-v2.json"
    desired_task_count = 1
  }

  ecs_cluster_name = "takouna"
  environment      = "dev"
  target_type      = "ip"
  network_mode     = "awsvpc"
  compatibilities  = "EC2"
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
}

module "dev-bookings-v1" {
  source                     = "../../modules/services"
  network_mode               = "${local.network_mode}"
  vpc_id                     = "${module.dev-vcp.vpc_id}"
  environment                = "${local.environment}"
  service_name               = "${local.bookings-v1["service_name"]}"
  service_port               = "${local.bookings-v1["service_port"]}"
  desired_task_count         = "${local.bookings-v1["desired_task_count"]}"
  iam_service_role           = "${module.dev-ecs.iam_service_role}"
  ecs_cluster_id             = "${module.dev-ecs.ecs_cluster_id}"
  ecs_cluster_name           = "${module.dev-ecs.ecs_cluster_name}"
  container_definitions      = "${file("${local.bookings-v1["tasks_definitions"]}")}"
  alb_target_group_arn       = "${module.dev-ecs.alb_target_group_arn}"
  security_group_instance_id = "${module.dev-vcp.security_group_instance_id}"
  vpc_subnets                = "${module.dev-vcp.vpc_subnets}"
  compatibilities            = "${local.compatibilities}"
}

module "dev-bookings-v2" {
  source                     = "../../modules/services"
  network_mode               = "${local.network_mode}"
  vpc_id                     = "${module.dev-vcp.vpc_id}"
  environment                = "${local.environment}"
  service_name               = "${local.bookings-v2["service_name"]}"
  service_port               = "${local.bookings-v2["service_port"]}"
  desired_task_count         = "${local.bookings-v2["desired_task_count"]}"
  iam_service_role           = "${module.dev-ecs.iam_service_role}"
  ecs_cluster_id             = "${module.dev-ecs.ecs_cluster_id}"
  ecs_cluster_name           = "${module.dev-ecs.ecs_cluster_name}"
  container_definitions      = "${file("${local.bookings-v2["tasks_definitions"]}")}"
  alb_target_group_arn       = "${module.dev-ecs.alb_target_group_arn}"
  security_group_instance_id = "${module.dev-vcp.security_group_instance_id}"
  vpc_subnets                = "${module.dev-vcp.vpc_subnets}"
  compatibilities            = "${local.compatibilities}"
}
