output "alb_dns_name" {
  value = "${module.ecs.alb_dns_name}"
}

output "ecs_cluster_name" {
  value = "${module.ecs.ecs_cluster_name}"
}

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "ecs_cluster_id" {
  value = "${module.ecs.ecs_cluster_id}"
}

output "security_group_instance_id" {
  value = "${module.vpc.security_group_instance_id}"
}

output "vpc_subnets" {
  value = "${module.vpc.vpc_subnets}"
}

output "alb_target_group_name_ecs_blue" {
  value = "${module.ecs.alb_target_group_name_ecs_blue}"
}

output "alb_target_group_name_ecs_green" {
  value = "${module.ecs.alb_target_group_name_ecs_green}"
}

output "alb_target_group_arn_ecs_green" {
  value = "${module.ecs.alb_target_group_arn_ecs_green}"
}

output "alb_listener_arn" {
  value = "${module.ecs.alb_listener_arn}"
}

output "iam_service_role" {
  value = "${module.ecs.iam_service_role}"
}

output "tags" {
  value = "${module.label.tags}"
}

output "environment" {
  value = "${module.label.environment}"
}
