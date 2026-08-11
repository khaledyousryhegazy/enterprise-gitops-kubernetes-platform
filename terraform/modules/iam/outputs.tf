output "eks_cluster_role_arn" {
  value = module.eks_cluster_role.arn
}

output "eks_node_role_arn" {
  value = module.eks_node_role.arn
}

output "github_actions_role_arn" {
  value = module.github_actions_role.arn
}

output "vpc_cni_role_arn" {
  value = module.vpc_cni_role.arn
}

output "ebs_csi_role_arn" {
  value = module.ebs_csi_role.arn
}

output "aws_lb_controller_role_arn" {
  value = module.aws_lb_controller_role.arn
}

output "external_dns_role_arn" {
  value = module.external_dns_role.arn
}
