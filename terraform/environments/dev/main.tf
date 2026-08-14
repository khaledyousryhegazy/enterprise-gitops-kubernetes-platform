module "vpc" {
  source      = "../../modules/vpc"
  azs         = local.azs
  name_prefix = local.name_prefix
  vpc_cidr    = local.vpc_cidr
  tags        = local.tags
}

module "security_groups" {
  source                 = "../../modules/security_groups"
  name_prefix            = local.name_prefix
  tags                   = local.tags
  vpc_id                 = module.vpc.vpc_id
  node_security_group_id = module.eks_cluster.node_security_group_id
}

module "iam" {
  source            = "../../modules/iam"
  name_prefix       = local.name_prefix
  tags              = local.tags
  github_repository = var.github_repository
  cluster_name      = module.eks_cluster.cluster_name
}

module "eks_cluster" {
  source               = "../../modules/eks"
  name_prefix          = local.name_prefix
  tags                 = local.tags
  vpc_id               = module.vpc.vpc_id
  vpc_cni_role_arn     = module.iam.vpc_cni_role_arn
  private_subnets      = module.vpc.private_subnets
  eks_node_role_arn    = module.iam.eks_node_role_arn
  eks_cluster_role_arn = module.iam.eks_cluster_role_arn
  ebs_csi_role_arn     = module.iam.ebs_csi_role_arn
}
