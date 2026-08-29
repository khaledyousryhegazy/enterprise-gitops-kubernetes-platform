# Backend Repository
module "ecr_frontend" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "${var.name_prefix}-k8s-platform-frontend"

  repository_read_write_access_arns = [var.github_actions_role_arn]
  create_lifecycle_policy           = true
  repository_force_delete           = true
  repository_image_tag_mutability   = "IMMUTABLE"

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = var.tags
}

# Backend Repository
module "ecr_backend" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "${var.name_prefix}-k8s-platform-backend"

  repository_read_write_access_arns = [var.github_actions_role_arn]
  create_lifecycle_policy           = true
  repository_force_delete           = true
  repository_image_tag_mutability   = "IMMUTABLE"

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = var.tags
}
