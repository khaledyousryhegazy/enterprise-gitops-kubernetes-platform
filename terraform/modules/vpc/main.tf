module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.name_prefix}-vpc"
  cidr = var.vpc_cidr

  azs              = var.azs
  private_subnets  = [for k, v in var.azs : cidrsubnet(var.vpc_cidr, 8, k)]
  public_subnets   = [for k, v in var.azs : cidrsubnet(var.vpc_cidr, 8, k + 4)]
  database_subnets = [for k, v in var.azs : cidrsubnet(var.vpc_cidr, 8, k + 8)]

  create_database_subnet_route_table = true
  create_database_nat_gateway_route  = false

  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = var.tags
}
