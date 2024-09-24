# This files is used for definitions of shared parameters like VPC id to SSM Parameter Stores

resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${local.tags.Project}/vpc_id"
  type  = "String"
  value = aws_vpc.main.id
}

resource "aws_ssm_parameter" "public_subnet_ids" {
  name  = "/${local.tags.Project}/public_subnet_ids"
  type  = "StringList"
  value = join(",", aws_subnet.public[*].id)
}

resource "aws_ssm_parameter" "private_compute_subnet_ids" {
  name  = "/${local.tags.Project}/private_compute_subnet_ids"
  type  = "StringList"
  value = join(",", aws_subnet.compute[*].id)
}

resource "aws_ssm_parameter" "private_db_subnet_ids" {
  name  = "/${local.tags.Project}/private_db_subnet_ids"
  type  = "StringList"
  value = join(",", aws_subnet.db[*].id)
}
