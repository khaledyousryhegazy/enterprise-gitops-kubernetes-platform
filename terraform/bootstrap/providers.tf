provider "aws" {
  region = var.region
}

# Look up the already-created EKS cluster. This bootstrap root is intentionally
# separate from the Terraform root that creates the cluster.
data "aws_eks_cluster" "target" {
  name = var.cluster_name
}

provider "helm" {
  kubernetes {
    host = data.aws_eks_cluster.target.endpoint
    cluster_ca_certificate = base64decode(
      data.aws_eks_cluster.target.certificate_authority[0].data
    )

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args = [
        "eks",
        "get-token",
        "--cluster-name", var.cluster_name,
        "--region", var.region
      ]
    }
  }
}
