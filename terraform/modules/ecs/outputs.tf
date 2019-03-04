output "ecs_cluster_name" {
  value = "${aws_ecs_cluster.ecs.name}"
}

output "iam_service_role" {
  value = "${aws_iam_role.service.name}"
}

output "alb_target_group_arn" {
  value = "${aws_alb_target_group.ecs.arn}"
}

output "ecs_cluster_id" {
  value = "${aws_ecs_cluster.ecs.id}"
}

output "alb_dns_name"{
value = "${element(concat(aws_alb.ecs.*.dns_name, list("")), 0)}"
}
