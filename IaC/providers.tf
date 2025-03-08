#backend setup
terraform {
  backend "s3" {
    bucket = "moveo-terraform"
    key    = "state/terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}   