# resource "aws_ecr_repository" "default" {
#   name                 = "${local.tags.Project}-app"
#   image_tag_mutability = "IMMUTABLE"

#   image_scanning_configuration {
#     scan_on_push = true
#   }

#   tags = merge(local.tags, {
#     Name = "${local.tags.Project}-repository"
#     group = "${local.tags.Project}"
#   })
# }

# resource "null_resource" "push_image" {
#   provisioner "local-exec" {
#     command = "sh ${path.module}/dockerbuild.sh > ${path.module}/../../dockerbuild.log 2>&1"
#     environment = {
#       AWS_REGION     = local.region
#       AWS_ACCOUNT_ID = local.aws_account_id
#       REPOSITORY_NAME = aws_ecr_repository.default.name
#       PROJECT_NAME = local.tags.Project
#     }
#   }
# }
data "aws_ssm_parameter" "ecr_image_uri" {
  name = "/${local.tags.Project}/ecr/${local.tags.Project}-app/latest-image-uri"
}