# This files is used for definitions of shared parameters like VPC id to SSM Parameter Stores

resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${local.tags.Project}/vpc/vpc_id"
  type  = "String"
  value = aws_vpc.main.id
}

resource "aws_ssm_parameter" "public_subnet_ids" {
  name  = "/${local.tags.Project}/vpc/public_subnet_ids"
  type  = "StringList"
  value = join(",", aws_subnet.public[*].id)
}

resource "aws_ssm_parameter" "private_compute_subnet_ids" {
  name  = "/${local.tags.Project}/vpc/private_compute_subnet_ids"
  type  = "StringList"
  value = join(",", aws_subnet.compute[*].id)
}

resource "aws_ssm_parameter" "private_db_subnet_ids" {
  name  = "/${local.tags.Project}/vpc/private_db_subnet_ids"
  type  = "StringList"
  value = join(",", aws_subnet.db[*].id)
}
