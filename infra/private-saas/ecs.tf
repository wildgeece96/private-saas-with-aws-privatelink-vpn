
# ECS Cluster Definition
resource "aws_ecs_cluster" "main" {
  name = "${local.tags.Project}-cluster"

  tags = merge(local.tags, {
    Name = "private-saas-cluster"
  })
}

# ECS Task Definition
resource "aws_ecs_task_definition" "app" {
  family                   = "${local.tags.Project}-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }


  container_definitions = templatefile("${path.module}/task_definition.json", {
    image_url        = data.aws_ssm_parameter.ecr_image_uri.value
    container_name   = "app"
    log_group_region = local.region
    log_group_name   = aws_cloudwatch_log_group.app.name
  })
  tags = merge(local.tags, {
    Name = "private-saas-app-task"
  })
  depends_on = [aws_cloudwatch_log_group.app]
}

# ECS Service Definition
resource "aws_ecs_service" "app" {
  name            = "private-saas-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"
#   iam_role        = aws_iam_role.ecs_service.name

  network_configuration {
    subnets         = local.private_compute_subnet_ids
    security_groups = [aws_security_group.ecs_tasks.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = "app"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.http, aws_iam_role.ecs_execution_role]

  tags = merge(local.tags, {
    Name = "private-saas-service"
  })
}

# Security group for ECS tasks
resource "aws_security_group" "ecs_tasks" {
  name        = "private-saas-ecs-tasks-sg"
  description = "Security group for ECS tasks"
  vpc_id      = local.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    Name = "ecs-tasks-sg"
  })
}

# ECS Execution Role
resource "aws_iam_role" "ecs_execution_role" {
  name = "${local.tags.Project}-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(local.tags, {
    Name = "private-saas-ecs-execution-role"
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# IAM Role for ECS Service
# resource "aws_iam_role" "ecs_service" {
#   name = "${local.tags.Project}-ecs-service-role"

#   assume_role_policy = jsonencode({
#     Version = "2008-10-17"
#     Statement = [
#       {
#         Sid    = ""
#         Effect = "Allow"
#         Principal = {
#           Service = "ecs.amazonaws.com"
#         }
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
# }


# resource "aws_iam_role_policy" "ecs_service" {
#   name = "${local.tags.Project}-ecs-service-policy"
#   role = aws_iam_role.ecs_service.name

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "ec2:Describe*",
#           "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
#           "elasticloadbalancing:DeregisterTargets",
#           "elasticloadbalancing:Describe*",
#           "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
#           "elasticloadbalancing:RegisterTargets"
#         ]
#         Resource = "*"
#       }
#     ]
#   })
# }