output "vpc_id" {
  description = "The vpc id"
  value       = "${module.vpc.vpc_id}"
}

output "vpc_subnets" {
  description = "The vpc id"
  value       = "${module.vpc.public_subnets}"
}

output "aws_security_group_instance_id" {
  description = "The vpc id"
  value       = "${aws_security_group.instance.id}"
}

output "aws_security_group_alb_id" {
  description = "The vpc id"
  value       = "${aws_security_group.alb.id}"
}
