output "name" {
  description = "The vpc id"
  value       = "${aws_ecs_cluster.ecs.name}"
}

output "ecs_cluster" {
  description = "The vpc id"
  value       = "${aws_ecs_cluster.ecs.name}"
}

output "iam_service_role" {
  description = "The vpc id"
  value       = "${aws_iam_role.service.name}"
}

output "aws_alb_target_group_arn"{
      description = "The vpc id"
  value       = "${aws_alb_target_group.ecs.arn}"
}

output "id" {
    value ="${aws_ecs_cluster.ecs.id}"
}
