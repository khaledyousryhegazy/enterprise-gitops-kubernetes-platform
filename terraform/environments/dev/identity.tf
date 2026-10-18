# Keep Pod Identity associations in the environment root so Terraform creates
# them only after both the EKS cluster and the IAM roles exist.
resource "aws_secretsmanager_secret" "rds_app_database" {
  name        = "gitops-platform/rds/app"
  description = "Application database credentials for the GitOps platform backend"

  tags = local.tags
}

resource "aws_eks_pod_identity_association" "aws_lb_controller" {
  cluster_name    = module.eks_cluster.cluster_name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"
  role_arn        = module.iam.aws_lb_controller_role_arn
}

resource "aws_eks_pod_identity_association" "external_dns" {
  cluster_name    = module.eks_cluster.cluster_name
  namespace       = "app"
  service_account = "external-dns"
  role_arn        = module.iam.external_dns_role_arn
}

resource "aws_eks_pod_identity_association" "external_secrets" {
  cluster_name    = module.eks_cluster.cluster_name
  namespace       = "external-secrets"
  service_account = "external-secrets"
  role_arn        = module.iam.external_secrets_role_arn
}
