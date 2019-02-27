variable "name" {
  description = "The name of ecs cluster"
  type        = "string"
  default     = "takouna-ecs"
}

variable "environment" {
  description = "The name of ecs cluster"
  type        = "string"
}

variable "service_port" {
  description = "The name of ecs cluster"
  type        = "string"
}
variable "service_name" {
  description = "The name of ecs cluster"
  type        = "string"
  default     = "takouna-ecs"
}
variable "container_definitions" {
  description = "The name of ecs cluster"
  type        = "string"
}

variable "vpc_id" {
  description = "The name of ecs cluster"
  type        = "string"
}

variable "aws_alb_target_group_arn" {
  description = "The name of ecs cluster"
  type        = "string"
}


variable "aws_ecs_cluster_name" {
  description = "The name of ecs cluster"
  type        = "string"
}


variable "iam_service_role" {
  description = "The name of ecs cluster"
  type        = "string"
}

variable "aws_ecs_cluster_id" {
  description = "The name of ecs cluster"
  type        = "string"
}