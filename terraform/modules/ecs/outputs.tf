output "ecs_cluster_name" {
  value = "${aws_ecs_cluster.ecs.name}"
}

output "iam_service_role" {
  value = "${aws_iam_role.service.name}"
}

output "alb_target_group_arn_ecs_green" {
  value = "${aws_alb_target_group.ecs-green.arn}"
}

output "alb_target_group_arn_ecs_blue" {
  value = "${aws_alb_target_group.ecs-blue.arn}"
}

output "alb_target_group_name_ecs_green" {
  value = "${aws_alb_target_group.ecs-green.name}"
}

output "alb_target_group_name_ecs_blue" {
  value = "${aws_alb_target_group.ecs-blue.name}"
}


output "alb_listener_arn" {
  value = "${aws_alb_listener.ecs.arn}"
}
output "ecs_cluster_id" {
  value = "${aws_ecs_cluster.ecs.id}"
}

output "alb_dns_name"{
value = "${element(concat(aws_alb.ecs.*.dns_name, list("")), 0)}"
}
