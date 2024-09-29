resource "aws_cloudwatch_log_group" "app" {
  name = "/${local.tags.Project}/ecs/app"
}
