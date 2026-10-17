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
