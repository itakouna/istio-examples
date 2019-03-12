terraform {
  backend "s3" {
    bucket = "dev-terraform-state-files"
    key    = "dev/ecs/terraform.tfstate"
    region = "eu-central-1"
  }
}
