module "vpc" {
  source      = "../../modules/vpc"
  azs         = local.azs
  name_prefix = local.name_prefix
  vpc_cidr    = local.vpc_cidr
  tags        = local.tags
}

module "security_groups" {
  source      = "../../modules/security_groups"
  name_prefix = local.name_prefix
  tags        = local.tags
  vpc_id      = module.vpc.vpc_id
}
