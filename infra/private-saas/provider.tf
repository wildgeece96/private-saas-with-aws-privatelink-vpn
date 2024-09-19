
provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = local.tags
  }
}

terraform {
  backend "s3" {
    bucket = "tfstate-bucket"
    key    = "${locals.aws_account_id}/${locals.tags.Project}"
    region = locals.region
  }
}
