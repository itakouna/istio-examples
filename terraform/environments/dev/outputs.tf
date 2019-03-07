output "alb_dns_name" {
  value = "${module.dev-ecs.alb_dns_name}"
}

output "ecs_cluster_name" {
  value = "${module.dev-ecs.ecs_cluster_name}"
}
