module "iam_oidc_provider" {
  source = "terraform-aws-modules/iam/aws//modules/iam-oidc-provider"

  url = "https://github.com/khaledyousryhegazy"

  tags = var.tags
}

# module "iam_role_github_oidc" {
#   source    = "terraform-aws-modules/iam/aws//modules/iam-role"

#   enable_github_oidc = true

#   # This should be updated to suit your organization, repository, references/branches, etc.
#   oidc_wildcard_subjects = ["terraform-aws-modules/terraform-aws-iam:*"]

#   policies = {
#     S3ReadOnly = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
#   }

#   tags = {
#     Terraform   = "true"
#     Environment = "dev"
#   }
# }

module "iam_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role"

  name = "${var.name_prefix}-eks-roles"

  trust_policy_permissions = {
    TrustRoleAndServiceToAssume = {
      actions = [
        "sts:AssumeRole",
        "sts:TagSession",
      ]
      principals = [{
        type = "AWS"
        identifiers = [
          "arn:aws:iam::835367859851:user/anton",
        ]
      }]
    }
  }

  policies = {
    AmazonCognitoReadOnly      = "arn:aws:iam::aws:policy/AmazonCognitoReadOnly"
    AlexaForBusinessFullAccess = "arn:aws:iam::aws:policy/AlexaForBusinessFullAccess"
  }

  tags = var.tags
}
