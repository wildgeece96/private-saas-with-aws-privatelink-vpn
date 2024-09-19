terraform {
  required_version = ">= 1.4.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.67.0"  # "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "tfstate-bucket"
    key    = "${locals.aws_account_id}/${locals.tags.Project}"
    region = locals.region
  }
}
