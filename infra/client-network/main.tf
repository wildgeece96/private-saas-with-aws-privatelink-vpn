resource "aws_sns_topic" "this" {
  display_name = "VPCエンドポイント通知"
  # kms_master_key_id = "alias/aws/sns"

  tags = merge(local.tags, {
    Name = "${local.tags.Project}-vpc-endpoint-notifications"
  })
}

resource "aws_sns_topic_policy" "this" {
  arn    = aws_sns_topic.this.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

resource "aws_security_group" "vpc_endpoint" {
  name_prefix = "${local.tags.Project}-vpc-endpoint"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    Name = "${local.tags.Project}-vpc-endpoint-sg"
  })
}

resource "aws_vpc_endpoint" "this" {
  vpc_id            = aws_vpc.main.id
  service_name      = aws_vpc_endpoint_service.this.service_name
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.vpc_endpoint.id
  ]

  private_dns_enabled = true
  subnet_ids = [
    for i in range(var.az_count) : aws_subnet.private[i].id
  ]
  depends_on = [aws_vpc_endpoint_service.this, aws_route53_record.this]
}

resource "aws_vpc_endpoint_service" "this" {
  acceptance_required        = false
  network_load_balancer_arns = [var.nlb_arn]
  private_dns_name           = local.private_domain
  supported_ip_address_types = ["ipv4"]

  tags = merge(local.tags, {
    Name = "${local.tags.Project}-vpc-endpoint-service"
  })
}

resource "aws_vpc_endpoint_connection_notification" "this" {
  vpc_endpoint_service_id     = aws_vpc_endpoint_service.this.id
  connection_notification_arn = aws_sns_topic.this.arn
  connection_events           = ["Accept", "Reject", "Connect", "Delete"]
}


# resource "aws_route53_zone" "this" {
#   name = local.private_domain

#   vpc {
#     vpc_id = aws_vpc.main.id
#   }

#   tags = merge(local.tags, {
#     Name = "${local.tags.Project}-client-private-zone"
#   })
# }

# resource "aws_route53_record" "this" {
#   zone_id = aws_route53_zone.this.zone_id
#   name    = local.private_domain
#   records = [aws_vpc_endpoint.this.dns_entry[0].dns_name]
#   type    = "CNAME"
#   ttl     = 1800
#   # depends_on = [aws_vpc_endpoint_service.this, aws_vpc_endpoint.this]
# }

resource "aws_route53_record" "this" {
  zone_id = var.zone_id
  name    = "${aws_vpc_endpoint_service.this.private_dns_name_configuration[0].name}.${local.private_domain}"
  records = [aws_vpc_endpoint_service.this.private_dns_name_configuration[0].value]
  type    = aws_vpc_endpoint_service.this.private_dns_name_configuration[0].type
  ttl     = 1800
  depends_on = [aws_vpc_endpoint_service.this]
}
