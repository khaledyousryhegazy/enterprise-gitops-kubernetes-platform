data "aws_ami" "amz_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_availability_zones" "available" {}

locals {
  name_prefix = "gitops-k8s"
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
