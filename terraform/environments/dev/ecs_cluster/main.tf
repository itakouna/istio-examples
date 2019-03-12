locals {
  ecs_cluster_name = "takouna"
  environment      = "dev"
  target_type      = "ip"
  health_path      = "/health"
  team             = "backend developers"
}

module "label" {
  source    = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=master"
  namespace = "${local.ecs_cluster_name}"
  stage     = "${local.environment}"
  name      = "ecs-demo"
  delimiter = "-"
  tags      = "${map("Team", "${local.team}")}"
}

module "vpc" {
  source      = "../../../modules/vpc"
  name        = "${local.ecs_cluster_name}"
  environment = "${local.environment}"

  tags = "${module.label.tags}"
}

module "ecs" {
  source                     = "../../../modules/ecs"
  ecs_cluster_name           = "${local.ecs_cluster_name}"
  vpc_id                     = "${module.vpc.vpc_id}"
  environment                = "${local.environment}"
  vpc_subnets                = "${module.vpc.vpc_subnets}"
  security_group_instance_id = "${module.vpc.security_group_instance_id}"
  security_group_alb_id      = "${module.vpc.security_group_alb_id}"
  target_type                = "${local.target_type}"
  health_path                = "${local.health_path}"
  tags                       = "${module.label.tags}"
}
