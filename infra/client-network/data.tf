data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}


data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["vpce.amazonaws.com"]
    }
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.this.arn]
    effect    = "Allow"

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [aws_vpc_endpoint_service.this.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [local.aws_account_id]
    }
  }
}


data "aws_ssm_parameter" "vpc_id" {
  name = "/${local.tags.Project}/vpc/vpc_id"
}

data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${local.tags.Project}/vpc/public_subnet_ids"
}

data "aws_ssm_parameter" "private_compute_subnet_ids" {
  name = "/${local.tags.Project}/vpc/private_compute_subnet_ids"
}

data "aws_ssm_parameter" "route53_zone_id" {
  name = "/${local.tags.Project}/route53/zone_id"
}
