data "aws_availability_zones" "available" {}

locals {
  name_prefix = "enterprise-gitops-kubernetes-platform"
  region      = "us-east-1"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 2)

  tags = {
    Project     = local.name_prefix
    GithubRepo  = "https://github.com/khaledyousryhegazy/enterprise-gitops-kubernetes-platform"
    Environment = "DEVELOPMENT"
    Owner       = "Khaled"
    ManagedBy   = "Terraform"
  }
}
