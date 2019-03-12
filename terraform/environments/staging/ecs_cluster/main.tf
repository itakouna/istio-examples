locals {
  ecs_cluster_name          = "takouna"
  environment               = "staging"
  instance_type             = "t2.micro"
  instance_keypair          = ""
  instance_root_volume_size = "8"
  asg_desired_size          = "2"
  asg_min_size              = "1"
  asg_max_size              = "2"
  target_type               = "ip"
  health_path               = "/health"
  team                      = "backend developers"
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
  cidr        = "10.0.0.0/16"

  private_subnets = {
    "eu-central-1a" = "10.0.1.0/24"
    "eu-central-1b" = "10.0.2.0/24"
    "eu-central-1c" = "10.0.3.0/24"
  }

  public_subnets = {
    "eu-central-1a" = "10.0.101.0/24"
    "eu-central-1b" = "10.0.102.0/24"
    "eu-central-1c" = "10.0.103.0/24"
  }

  tags = "${module.label.tags}"
}

module "ecs" {
  source                    = "../../../modules/ecs"
  ecs_cluster_name          = "${local.ecs_cluster_name}"
  vpc_id                    = "${module.vpc.vpc_id}"
  instance_type             = "${local.instance_type}"
  instance_root_volume_size = "${local.instance_root_volume_size}"
  instance_keypair          = "${local.instance_keypair}"
  asg_desired_size          = "${local.asg_desired_size}"
  asg_min_size              = "${local.asg_min_size}"
  asg_max_size              = "${local.asg_max_size}"

  environment                = "${local.environment}"
  vpc_subnets                = "${module.vpc.vpc_subnets}"
  security_group_instance_id = "${module.vpc.security_group_instance_id}"
  security_group_alb_id      = "${module.vpc.security_group_alb_id}"
  target_type                = "${local.target_type}"
  health_path                = "${local.health_path}"
  tags                       = "${module.label.tags}"
}
