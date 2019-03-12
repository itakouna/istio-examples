terraform {
  backend "s3" {
    bucket = "staging-terraform-state-files"
    key    = "staging/ecs/terraform.tfstate"
    region = "eu-central-1"
  }
}
