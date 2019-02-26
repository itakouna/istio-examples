data "aws_availability_zones" "available" {}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "takouna-vpc"
  cidr = "${var.cidr}"

  azs = "${data.aws_availability_zones.available.names}"

  private_subnets = [
    "${lookup(var.private_subnets, "eu-central-1a")}",
    "${lookup(var.private_subnets, "eu-central-1b")}",
    "${lookup(var.private_subnets, "eu-central-1c")}",
  ]

  public_subnets = [
    "${lookup(var.public_subnets, "eu-central-1a")}",
    "${lookup(var.public_subnets, "eu-central-1b")}",
    "${lookup(var.public_subnets, "eu-central-1c")}",
  ]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
