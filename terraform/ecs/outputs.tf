output "ecs_cluster_name" {
  description = "The vpc id"
  value       = "${aws_ecs_cluster.ecs.name}"
}
