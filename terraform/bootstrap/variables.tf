variable "region" {
  description = "AWS region where the existing EKS cluster is deployed."
  type        = string
  validation {
    condition     = length(trimspace(var.region)) > 0
    error_message = "region must not be empty."
  }
}

variable "cluster_name" {
  description = "Exact name of the existing EKS cluster created by terraform/environments/dev."
  type        = string
  validation {
    condition     = length(trimspace(var.cluster_name)) > 0
    error_message = "cluster_name must not be empty."
  }
}

variable "argocd_chart_version" {
  description = "Pinned version of the Argo CD Helm chart from the Argo Helm repository."
  type        = string
  default     = "7.7.13"
}

variable "aws_lb_controller_chart_version" {
  description = "Pinned AWS Load Balancer Controller Helm chart version."
  type        = string
  default     = "1.14.0"
}
