terraform {
  required_version = ">= 1.4.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.67.0"
    }
  }
  backend "s3" {
    bucket = "060795931415-ap-northeast-1-tfstate-bucket"
    key    = "private-saas/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
