locals {
  ecs_cluster_name = "takouna"
  environment      = "dev"
  bookings_service = "bookings"
  movies_service   = "movies"
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
}

module "dev-bookings" {
  source                = "../../modules/services"
  vpc_id                = "${module.dev-vcp.vpc_id}"
  environment           = "${local.environment}"
  service_name          = "${local.bookings_service}"
  service_port          = "5003"
  iam_service_role      = "${module.dev-ecs.iam_service_role}"
  ecs_cluster_id        = "${module.dev-ecs.ecs_cluster_id}"
  ecs_cluster_name      = "${module.dev-ecs.ecs_cluster_name}"
  container_definitions = "${file("tasks-definitions/bookings.json")}"
  alb_target_group_arn  = "${module.dev-ecs.alb_target_group_arn}"
}

module "dev-movies" {
  source                = "../../modules/services"
  vpc_id                = "${module.dev-vcp.vpc_id}"
  environment           = "${local.environment}"
  service_name          = "${local.movies_service}"
  service_port          = "5001"
  iam_service_role      = "${module.dev-ecs.iam_service_role}"
  ecs_cluster_id        = "${module.dev-ecs.ecs_cluster_id}"
  ecs_cluster_name      = "${module.dev-ecs.ecs_cluster_name}"
  container_definitions = "${file("tasks-definitions/bookings.json")}"
  alb_target_group_arn  = "${module.dev-ecs.alb_target_group_arn}"
}
