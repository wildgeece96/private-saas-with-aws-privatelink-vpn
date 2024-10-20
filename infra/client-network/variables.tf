# variable "domain_name" {
#   type        = string
#   description = "Domain Name"
# }

variable "nlb_arn" {
  type        = string
  description = "Network Load Balancer ARN to connect from VPC Endpoint"
  default = "arn:aws:elasticloadbalancing:ap-northeast-1:060795931415:loadbalancer/net/tf-lb-20241010120932646300000003/ed68cbcc8b7e516e"
}

variable "az_count" {
  type        = number
  description = "Availability Zone Count"
  default = 2
}

variable "zone_id" {
  type        = string
  description = "Route 53 Zone ID"
  default = "Z0283255FBNFHSFUJ7OZ"
}
