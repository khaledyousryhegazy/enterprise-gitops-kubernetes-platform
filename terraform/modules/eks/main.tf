module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "${var.name_prefix}-cluster"
  kubernetes_version = "1.33"

  addons = {
    eks-pod-identity-agent = {
      before_compute = true
    }

    coredns    = {}
    kube-proxy = {}
    aws-ebs-csi-driver = {
      pod_identity_association = [{
        role_arn        = var.ebs_csi_role_arn
        service_account = "ebs-csi-controller-sa"
      }]
    }
    vpc-cni = {
      before_compute = true
      pod_identity_association = [{
        role_arn        = var.vpc_cni_role_arn
        service_account = "aws-node"
      }]
    }
  }

  enable_cluster_creator_admin_permissions = false
  endpoint_public_access                   = true
  endpoint_private_access                  = true
  authentication_mode                      = "API"

  access_entries = {
    khaled = {
      principal_arn = "arn:aws:iam::604275788373:user/khaled"

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  vpc_id                   = var.vpc_id
  subnet_ids               = var.private_subnets
  control_plane_subnet_ids = var.private_subnets

  create_kms_key = false
  encryption_config = {
    resources        = ["secrets"]
    provider_key_arn = var.kms_key_arn
  }

  enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  iam_role_arn = var.eks_cluster_role_arn

  eks_managed_node_groups = {
    "${var.name_prefix}-node_group" = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["m7i-flex.large"]

      iam_role_arn = var.eks_node_role_arn

      min_size     = 2
      max_size     = 5
      desired_size = 3
      disk_size    = 20
      tags         = var.tags
    }
  }

  tags = var.tags
}
