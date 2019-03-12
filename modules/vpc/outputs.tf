output "vpc_id" {
  description = "The vpc id"
  value       = "${module.vpc.vpc_id}"
}

output "vpc_subnets" {
  description = "The vpc_subnets of vpc"
  value       = "${module.vpc.public_subnets}"
}

output "security_group_instance_id" {
  description = "The id of security group for ECS instances"
  value       = "${aws_security_group.instance.id}"
}

output "security_group_alb_id" {
  description = "The id of security group for ECS ALB"
  value       = "${aws_security_group.alb.id}"
}
