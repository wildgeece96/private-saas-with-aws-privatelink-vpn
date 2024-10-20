locals {
  tags = {
    Terraform = "true"
    Stack     = "client-network"
    Project   = yamldecode(file("../shared_variables.yaml")).project_id
  }
  region                     = yamldecode(file("../shared_variables.yaml")).region
  aws_account_id             = data.aws_caller_identity.current.account_id
  vpc_id                     = data.aws_ssm_parameter.vpc_id.value
  public_subnet_ids          = split(",", data.aws_ssm_parameter.public_subnet_ids.value)
  private_compute_subnet_ids = split(",", data.aws_ssm_parameter.private_compute_subnet_ids.value)
  private_domain             = yamldecode(file("../shared_variables.yaml")).domain
}
