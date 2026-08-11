# ============================================================
# GitHub OIDC Provider
# ============================================================

module "github_oidc_provider" {
  source = "terraform-aws-modules/iam/aws//modules/iam-oidc-provider"

  url = "https://token.actions.githubusercontent.com"

  tags = var.tags
}

# ============================================================
# EKS Cluster Role
# ============================================================

module "eks_cluster_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role"

  name = "${var.name_prefix}-eks-cluster-role"

  trust_policy_permissions = {
    eks = {
      principals = [{
        type        = "Service"
        identifiers = ["eks.amazonaws.com"]
      }]

      actions = ["sts:AssumeRole"]
    }
  }

  policies = {
    AmazonEKSClusterPolicy = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  }

  tags = var.tags
}

# ============================================================
# EKS Node Role
# ============================================================

module "eks_node_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role"

  name = "${var.name_prefix}-eks-node-role"

  trust_policy_permissions = {
    ec2 = {
      principals = [{
        type        = "Service"
        identifiers = ["ec2.amazonaws.com"]
      }]

      actions = ["sts:AssumeRole"]
    }
  }

  policies = {
    AmazonEKSWorkerNodePolicy = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"

    AmazonEC2ContainerRegistryPullOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"

    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  tags = var.tags
}

# ============================================================
# GitHub Actions OIDC Role
# ============================================================

module "github_actions_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role"

  name = "${var.name_prefix}-github-actions-role"

  enable_github_oidc = true

  oidc_wildcard_subjects = [
    "repo:${var.github_repository}:*"
  ]

  policies = {
    AmazonEC2ContainerRegistryPowerUser = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
  }

  tags = var.tags
}

# ============================================================
# VPC CNI Pod Identity Role
# ============================================================

module "vpc_cni_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role"

  name = "${var.name_prefix}-vpc-cni-role"

  trust_policy_permissions = {
    pods = {
      principals = [{
        type        = "Service"
        identifiers = ["pods.eks.amazonaws.com"]
      }]

      actions = [
        "sts:AssumeRole",
        "sts:TagSession"
      ]
    }
  }

  policies = {
    AmazonEKS_CNI_Policy = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  }

  tags = var.tags
}

# ============================================================
# EBS CSI Driver Pod Identity Role
# ============================================================

module "ebs_csi_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role"

  name = "${var.name_prefix}-ebs-csi-role"

  trust_policy_permissions = {
    pods = {
      principals = [{
        type        = "Service"
        identifiers = ["pods.eks.amazonaws.com"]
      }]

      actions = [
        "sts:AssumeRole",
        "sts:TagSession"
      ]
    }
  }

  policies = {
    AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  }

  tags = var.tags
}

# ============================================================
# AWS Load Balancer Controller Role
# ============================================================

module "aws_lb_controller_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role"

  name = "${var.name_prefix}-aws-lb-controller-role"

  trust_policy_permissions = {
    pods = {
      principals = [{
        type        = "Service"
        identifiers = ["pods.eks.amazonaws.com"]
      }]

      actions = [
        "sts:AssumeRole",
        "sts:TagSession"
      ]
    }
  }

  tags = var.tags
}

# ============================================================
# ExternalDNS Role
# ============================================================

module "external_dns_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role"

  name = "${var.name_prefix}-external-dns-role"

  trust_policy_permissions = {
    pods = {
      principals = [{
        type        = "Service"
        identifiers = ["pods.eks.amazonaws.com"]
      }]

      actions = [
        "sts:AssumeRole",
        "sts:TagSession"
      ]
    }
  }

  tags = var.tags
}
