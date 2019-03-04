variable "ecs_cluster_name" {
  description = "The name of ecs cluster"
  type        = "string"
}

variable "vpc_id" {
  description = "The id of vpc"
  type        = "string"
}

variable "vpc_subnets" {
  description = "The vpc_subnets of vpc"
  type        = "list"
}

variable "environment" {
  description = "The deployment environment name"
  type        = "string"
}

variable "security_group_instance_id" {
  description = "The id of security group for ECS instances"
  type        = "string"
}

variable "security_group_alb_id" {
  description = "The id of security group for ECS ALB"
  type        = "string"
}

variable "target_type" {
  type = "string"
}