locals {
  tags = {
    Terraform = "true"
    Project   = "private-saas"
  }
  region = "ap-northeast-1"

  aws_account_id = data.aws_caller_identity.current.account_id
}