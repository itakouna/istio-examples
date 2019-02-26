output "vpc_id" {
  description = "The vpc id"
  value       = "${module.vpc.vpc_id}"
}

output "vpc_subnets" {
  description = "The vpc id"
  value       = "${module.vpc.public_subnets}"
}
