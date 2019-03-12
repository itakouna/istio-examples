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

variable "health_path" {
  type    = "string"
  default = "/"
}

variable "tags" {
  description = "Tags of ecs cluster"
  type        = "map"
}

variable "instance_keypair" {
  description = "The instance_keypair of ecs cluster by default create new key pair"
  type        = "string"
}

variable "instance_type" {
  description = "The instance type of ecs cluster"
  type        = "string"
}

variable "instance_root_volume_size" {
  description = "The instance root volume size in GB of ecs cluster"
  type        = "string"
}

variable "asg_desired_size" {
  description = " Autoscaling group desired size of ecs cluster"

  type = "string"
}

variable "asg_max_size" {
  description = " Autoscaling group maximum size of ecs cluster"
  type        = "string"
}

variable "asg_min_size" {
  description = " Autoscaling group minimum size of ecs cluster"
  type        = "string"
}
