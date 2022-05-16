terraform {
  required_version = ">= 0.14.0"

  required_providers {
    aws = {
      version = ">= 4.14.0"
    }
  }

  backend "s3" {
    bucket  = "ships-terraform-state-s3-bucket"
    region  = "ap-northeast-1"
    key     = "terraform.tfstate"
    encrypt = true
  }
}