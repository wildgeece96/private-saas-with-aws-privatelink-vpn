terraform {
  required_version = ">= 1.4.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.70.0"
    }
  }
  backend "s3" {
    bucket = "060795931415-ap-northeast-1-tfstate-bucket"
    key    = "client-network/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
