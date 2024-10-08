# NLB to forward ALB for ECS
# resource "aws_security_group" "allow_tls" {
#   name        = "allow_tls"
#   description = "Allow TLS inbound traffic"
#   vpc_id      = local.vpc_id

#   ingress {
#     description      = "Allow 443/tcp from anywhere"
#     from_port        = 443
#     to_port          = 443
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   egress {
#     description      = "Allow all traffic to anywhere"
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }
# }

# resource "aws_lb" "nlb" {
#   load_balancer_type = "network"
#   internal           = true
#   ip_address_type    = "ipv4"

#   enable_deletion_protection = true

#   security_groups = [aws_security_group.allow_tls.id]
#   subnets         = local.public_subnet_ids
# }

# resource "aws_lb_target_group" "alb" {
#   target_type = "alb"
#   port        = 443
#   protocol    = "TCP"
#   vpc_id      = local.vpc_id

#   health_check {
#     protocol = "HTTPS"
#   }
# }

# resource "aws_lb_target_group_attachment" "nlb" {
#   target_group_arn = aws_lb_target_group.alb.arn
#   target_id        = aws_lb.main.arn
#   port             = 443
# }

# resource "aws_lb_listener" "nlb_to_alb" {
#   load_balancer_arn = aws_lb.main.arn
#   port              = 443
#   protocol          = "TCP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.alb.arn
#   }
# }