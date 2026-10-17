output "argocd_namespace" {
  description = "Namespace where Argo CD is installed."
  value       = helm_release.argocd.namespace
}

output "argocd_chart_version" {
  description = "Installed Argo CD Helm chart version."
  value       = helm_release.argocd.version
}

output "argocd_release_status" {
  description = "Terraform-reported status of the Argo CD Helm release."
  value       = helm_release.argocd.status
}

output "aws_load_balancer_controller_chart_version" {
  description = "Installed AWS Load Balancer Controller Helm chart version."
  value       = helm_release.aws_load_balancer_controller.version
}

output "aws_load_balancer_controller_release_status" {
  description = "Terraform-reported status of the AWS Load Balancer Controller release."
  value       = helm_release.aws_load_balancer_controller.status
}
