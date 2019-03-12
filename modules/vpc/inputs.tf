variable "tags" {
  description = "Tags of ecs cluster"
  type        = "map"
}

variable "region" {
  description = "The region to deploy the VPC in, e.g: us-east-1."
  type        = "string"
  default     = "eu-central-1"
}

variable "name" {
  description = "The name of ecs cluster"
  type        = "string"
}

variable "environment" {
  description = "The name of ecs cluster"
  type        = "string"
}

variable "cidr" {
  description = "The CIDR block for the VPC, e.g: 10.0.0.0/16"
  type        = "string"
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  description = "A map of availability zones to CIDR blocks, which will be set up as subnets."
  type        = "map"

  default = {
    "eu-central-1a" = "10.0.1.0/24"
    "eu-central-1b" = "10.0.2.0/24"
    "eu-central-1c" = "10.0.3.0/24"
  }
}

variable "public_subnets" {
  description = "A map of availability zones to CIDR blocks, which will be set up as subnets."
  type        = "map"

  default = {
    "eu-central-1a" = "10.0.101.0/24"
    "eu-central-1b" = "10.0.102.0/24"
    "eu-central-1c" = "10.0.103.0/24"
  }
}
