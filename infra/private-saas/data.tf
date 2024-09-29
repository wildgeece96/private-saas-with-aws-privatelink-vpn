data "aws_caller_identity" "current" {}

data "aws_ssm_parameter" "vpc_id" {
  name = "/${local.tags.Project}/vpc/vpc_id"
}

data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${local.tags.Project}/vpc/public_subnet_ids"
}

data "aws_ssm_parameter" "private_compute_subnet_ids" {
  name = "/${local.tags.Project}/vpc/private_compute_subnet_ids"
}
