variable "name" {
  description = "The name of ecs cluster"
  type        = "string"
  default     = "takouna-ecs"
}
variable "vpc_id" {
  description = "The name of ecs cluster"
  type        = "string"
}



variable "vpc_subnets" {
  description = "The name of ecs cluster"
  type        = "list"
}

variable "environment" {
  description = "The name of ecs cluster"
  type        = "string"
  default     = "dev"
}


variable "aws_security_group_instance_id" {
   description = "The name of ecs cluster"
  type        = "string"
}

variable "aws_security_group_alb_id" {
   description = "The name of ecs cluster"
  type        = "string"
}
