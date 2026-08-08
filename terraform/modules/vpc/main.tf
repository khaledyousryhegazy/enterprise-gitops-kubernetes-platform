module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.name_prefix}-vpc"
  cidr = "10.0.0.0/16"

  azs                 = var.azs
  private_subnets     = [for k, v in var.azs : cidrsubnet(var.vpc_cidr, 8, k)]
  public_subnets      = [for k, v in var.azs : cidrsubnet(var.vpc_cidr, 8, k + 4)]
  database_subnets    = [for k, v in var.azs : cidrsubnet(var.vpc_cidr, 8, k + 8)]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = var.tags
}
