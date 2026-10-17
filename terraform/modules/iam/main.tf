# ============================================================
# GitHub Actions OIDC Role
# ============================================================

module "github_actions_role" {
  source  = "unfunco/oidc-github/aws"
  version = "~> 3.0"

  github_subjects = [
    "khaledyousryhegazy@147883540/enterprise-gitops-kubernetes-platform@1327588043:ref:refs/heads/main"
  ]

  iam_role_policy_names = [
    "AmazonEC2ContainerRegistryPowerUser"
  ]
}

# ============================================================
# EKS Cluster Role
# ============================================================

module "eks_cluster_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role"

  name = "${var.name_prefix}-cluster-role"

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

  name = "${var.name_prefix}-node-role"

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

data "aws_iam_policy_document" "aws_lb_controller" {
  statement {
    actions   = ["iam:CreateServiceLinkedRole"]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "iam:AWSServiceName"
      values   = ["elasticloadbalancing.amazonaws.com"]
    }
  }

  statement {
    actions = [
      "ec2:DescribeAccountAttributes", "ec2:DescribeAddresses", "ec2:DescribeAvailabilityZones",
      "ec2:DescribeInternetGateways", "ec2:DescribeVpcs", "ec2:DescribeVpcPeeringConnections",
      "ec2:DescribeSubnets", "ec2:DescribeSecurityGroups", "ec2:DescribeInstances",
      "ec2:DescribeNetworkInterfaces", "ec2:DescribeTags", "ec2:GetCoipPoolUsage",
      "ec2:DescribeCoipPools", "ec2:GetSecurityGroupsForVpc", "ec2:DescribeIpamPools",
      "ec2:DescribeRouteTables", "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeLoadBalancerAttributes", "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeListenerCertificates", "elasticloadbalancing:DescribeSSLPolicies",
      "elasticloadbalancing:DescribeRules", "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetGroupAttributes", "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:DescribeTags", "elasticloadbalancing:DescribeTrustStores",
      "elasticloadbalancing:DescribeListenerAttributes", "elasticloadbalancing:DescribeCapacityReservation"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "cognito-idp:DescribeUserPoolClient", "acm:ListCertificates", "acm:DescribeCertificate",
      "iam:ListServerCertificates", "iam:GetServerCertificate", "waf-regional:GetWebACL",
      "waf-regional:GetWebACLForResource", "waf-regional:AssociateWebACL",
      "waf-regional:DisassociateWebACL", "wafv2:GetWebACL", "wafv2:GetWebACLForResource",
      "wafv2:AssociateWebACL", "wafv2:DisassociateWebACL", "shield:GetSubscriptionState",
      "shield:DescribeProtection", "shield:CreateProtection", "shield:DeleteProtection"
    ]
    resources = ["*"]
  }

  statement {
    actions   = ["ec2:AuthorizeSecurityGroupIngress", "ec2:RevokeSecurityGroupIngress"]
    resources = ["*"]
  }

  statement {
    actions   = ["ec2:CreateSecurityGroup"]
    resources = ["*"]
  }

  statement {
    actions   = ["ec2:CreateTags"]
    resources = ["arn:aws:ec2:*:*:security-group/*"]
    condition {
      test     = "StringEquals"
      variable = "ec2:CreateAction"
      values   = ["CreateSecurityGroup"]
    }
    condition {
      test     = "Null"
      variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
      values   = ["false"]
    }
  }

  statement {
    actions   = ["ec2:CreateTags", "ec2:DeleteTags"]
    resources = ["arn:aws:ec2:*:*:security-group/*"]
    condition {
      test     = "Null"
      variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
      values   = ["true"]
    }
    condition {
      test     = "Null"
      variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
      values   = ["false"]
    }
  }

  statement {
    actions   = ["ec2:AuthorizeSecurityGroupIngress", "ec2:RevokeSecurityGroupIngress", "ec2:DeleteSecurityGroup"]
    resources = ["*"]
    condition {
      test     = "Null"
      variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
      values   = ["false"]
    }
  }

  statement {
    actions   = ["elasticloadbalancing:CreateLoadBalancer", "elasticloadbalancing:CreateTargetGroup"]
    resources = ["*"]
    condition {
      test     = "Null"
      variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
      values   = ["false"]
    }
  }

  statement {
    actions = [
      "elasticloadbalancing:CreateListener", "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:CreateRule", "elasticloadbalancing:DeleteRule"
    ]
    resources = ["*"]
  }

  statement {
    actions = ["elasticloadbalancing:AddTags", "elasticloadbalancing:RemoveTags"]
    resources = [
      "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
      "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
      "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*"
    ]
    condition {
      test     = "Null"
      variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
      values   = ["true"]
    }
    condition {
      test     = "Null"
      variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
      values   = ["false"]
    }
  }

  statement {
    actions = ["elasticloadbalancing:AddTags", "elasticloadbalancing:RemoveTags"]
    resources = [
      "arn:aws:elasticloadbalancing:*:*:listener/net/*/*/*",
      "arn:aws:elasticloadbalancing:*:*:listener/app/*/*/*",
      "arn:aws:elasticloadbalancing:*:*:listener-rule/net/*/*/*",
      "arn:aws:elasticloadbalancing:*:*:listener-rule/app/*/*/*"
    ]
  }

  statement {
    actions = [
      "elasticloadbalancing:ModifyLoadBalancerAttributes", "elasticloadbalancing:SetIpAddressType",
      "elasticloadbalancing:SetSecurityGroups", "elasticloadbalancing:SetSubnets",
      "elasticloadbalancing:DeleteLoadBalancer", "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:ModifyTargetGroupAttributes", "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:ModifyListenerAttributes", "elasticloadbalancing:ModifyCapacityReservation",
      "elasticloadbalancing:ModifyIpPools"
    ]
    resources = ["*"]
    condition {
      test     = "Null"
      variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
      values   = ["false"]
    }
  }

  statement {
    actions = ["elasticloadbalancing:AddTags"]
    resources = [
      "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
      "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
      "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "elasticloadbalancing:CreateAction"
      values   = ["CreateTargetGroup", "CreateLoadBalancer"]
    }
    condition {
      test     = "Null"
      variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
      values   = ["false"]
    }
  }

  statement {
    actions   = ["elasticloadbalancing:RegisterTargets", "elasticloadbalancing:DeregisterTargets"]
    resources = ["arn:aws:elasticloadbalancing:*:*:targetgroup/*/*"]
  }

  statement {
    actions = [
      "elasticloadbalancing:SetWebAcl", "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:AddListenerCertificates", "elasticloadbalancing:RemoveListenerCertificates",
      "elasticloadbalancing:ModifyRule", "elasticloadbalancing:SetRulePriorities"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "aws_lb_controller" {
  name        = "${var.name_prefix}-aws-lb-controller"
  description = "Permissions for the AWS Load Balancer Controller"
  policy      = data.aws_iam_policy_document.aws_lb_controller.json
  tags        = var.tags
}

module "aws_lb_controller_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role"

  name = "${var.name_prefix}-aws-lb-role"

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
    AWSLoadBalancerController = aws_iam_policy.aws_lb_controller.arn
  }

  tags = var.tags
}

# ============================================================
# ExternalDNS Role
# ============================================================

module "external_dns_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role"

  name = "${var.name_prefix}-extrnl-dns-role"

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
