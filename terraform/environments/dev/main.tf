locals {
  service_name = "bookings"
  cluster_name  = "takouna"
  environment  = "dev"
}

module "dev-vcp" {
  source      = "../../modules/vpc"
  name        = "${local.cluster_name}"
  environment = "${local.environment}"
}

module "dev-ecs" {
  source                         = "../../modules/ecs"
  name                           = "${local.cluster_name}"
  vpc_id                         = "${module.dev-vcp.vpc_id}"
  environment                    = "${local.environment}"
  vpc_subnets                    = "${module.dev-vcp.vpc_subnets}"
  aws_security_group_instance_id = "${module.dev-vcp.aws_security_group_instance_id}"
  aws_security_group_alb_id      = "${module.dev-vcp.aws_security_group_alb_id}"
}

module "dev-bookings" {
  source                   = "../../modules/services"
  name                     = "${local.service_name}"
  vpc_id                   = "${module.dev-vcp.vpc_id}"
  environment              = "${local.environment}"
  service_name             = "bookings"
  service_port             = "5003"
  iam_service_role         = "${module.dev-ecs.iam_service_role}"
  aws_ecs_cluster_id       = "${module.dev-ecs.id}"
  aws_ecs_cluster_name     = "${module.dev-ecs.name}"
  container_definitions    = "${file("tasks-definitions/bookings.json")}"
  aws_alb_target_group_arn = "${module.dev-ecs.aws_alb_target_group_arn}"
}
