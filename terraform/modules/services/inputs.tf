variable "ecs_cluster_name" {
  description = "The name of ecs cluster"
  type        = "string"
}

variable "environment" {
  description = "The deployment environment name"
  type        = "string"
}

variable "service_port" {
  description = "The port of service"
  type        = "string"
}

variable "service_name" {
  description = "The name of service"
  type        = "string"
}

variable "container_definitions" {
  description = "The definitions of ecs container"
  type        = "string"
}

variable "vpc_id" {
  description = "The id of vpc"
  type        = "string"
}

variable "alb_target_group_arn" {
  description = "ARN of ALB target group"
  type        = "string"
}

variable "iam_service_role" {
  description = "The iam ecs service role"
  type        = "string"
}

variable "ecs_cluster_id" {
  description = "The id of ecs cluster"
  type        = "string"
}

variable "network_mode" {
  type        = "string"
}

variable "security_group_instance_id" {
  description = "The id of security group for ECS instances"
  type        = "string"
}

variable "vpc_subnets" {
  description = "The vpc_subnets of vpc"
  type        = "list"
}
variable "compatibilities" {
  type        = "string"
}
