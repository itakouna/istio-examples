terraform {
  backend "s3" {
    bucket = "dev-terraform-state-files"
    key    = "dev/services/terraform.tfstate"
    region = "eu-central-1"
  }
}

data "terraform_remote_state" "ecs" {
  backend = "s3"

  config {
    bucket = "dev-terraform-state-files"
    key    = "dev/ecs/terraform.tfstate"
    region = "eu-central-1"
  }
}
