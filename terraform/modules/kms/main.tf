data "aws_caller_identity" "current" {}

module "kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 1.0"

  # Aliases
  aliases                 = [var.name_prefix]
  aliases_use_name_prefix = true

  key_owners = [data.aws_caller_identity.current.arn]

  tags = var.tags
}
