variable "name" {
  description = "The name of ecs cluster"
  type        = "string"
  default     = "takouna-ecs"
}

variable "instance_keypair" {
  description = "The instance_keypair of ecs cluster by default create new key pair"
  type        = "string"
  default     = ""
}

variable "tags" {
  description = "Tags of ecs cluster"
  type        = "map"

  default = {
    "name" = "takouna"
  }
}

variable "instance_type" {
  description = "The instance type of ecs cluster"
  type        = "string"
  default     = "t2.micro"
}

variable "instance_root_volume_size" {
  description = "The instance root volume size in GB of ecs cluster"
  type        = "string"
  default     = "8"
}

variable "asg_desired_size" {
  description = " Autoscaling group desired size of ecs cluster"

  type    = "string"
  default = "2"
}

variable "asg_max_size" {
  description = " Autoscaling group maximum size of ecs cluster"
  type        = "string"
  default     = "2"
}

variable "asg_min_size" {
  description = " Autoscaling group minimum size of ecs cluster"
  type        = "string"
  default     = "1"
}
