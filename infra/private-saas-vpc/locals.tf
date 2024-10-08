locals {
  tags = {
    Terraform = "true"
    Project   = yamldecode(file("../shared_variables.yaml")).project_id
    Stack     = "private-saas-vpc"
  }
  region = yamldecode(file("../shared_variables.yaml")).region
  aws_account_id = data.aws_caller_identity.current.account_id
  domain                     = yamldecode(file("../shared_variables.yaml")).domain
}