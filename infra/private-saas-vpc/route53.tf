resource "aws_route53_zone" "main" {
  name = local.domain

  tags = merge(local.tags, {
    Name = "${local.tags.Project}-route53-zone"
  })
}

resource "aws_ssm_parameter" "route53_zone_id" {
  name  = "/${local.tags.Project}/route53/zone_id"
  type  = "String"
  value = aws_route53_zone.main.zone_id
}

import {
  id = "Z0818824NQ4PGYT9DKM4"
  to = aws_route53_zone.main
}