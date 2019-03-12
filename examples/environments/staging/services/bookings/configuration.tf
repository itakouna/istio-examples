terraform {
  backend "s3" {
    bucket = "staging-terraform-state-files"
    key    = "staging/services/terraform.tfstate"
    region = "eu-central-1"
  }
}

data "terraform_remote_state" "ecs" {
  backend = "s3"

  config {
    bucket = "staging-terraform-state-files"
    key    = "staging/ecs/terraform.tfstate"
    region = "eu-central-1"
  }
}
