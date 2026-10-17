# Terraform Bootstrap: Argo CD

This Terraform root installs **Argo CD only** into an existing EKS cluster.
Monitoring is intentionally out of scope for this folder for now.

## Prerequisites

- `terraform/environments/dev` has already created the EKS cluster.
- AWS credentials are configured and authorized to describe the EKS cluster.
- The identity used by `aws eks get-token` is authorized to access Kubernetes.
- The AWS CLI is installed and available on `PATH`.

## Configure

The included `values.tfvars` matches the current dev environment:
`gitops-k8s-cluster` in `us-east-1`. Update it if the environment's cluster name
or region changes.

Run these commands from this directory:

```bash
terraform init -backend-config=backend.hcl
terraform plan -var-file=values.tfvars
terraform apply -var-file=values.tfvars
```

The chart version is pinned by default to `7.7.13` to match the version discussed
when this folder was created. Before using it for a production deployment, verify
the currently supported chart version and upgrade it deliberately.

## State

Terraform treats this directory as a separate root module with a dedicated S3
state key. Its backend settings follow `environments/dev/backend.hcl`; initialize
with `-backend-config=backend.hcl` and never reuse the dev state key.

## Important notes

- Do not run this before the EKS cluster exists.
- The Helm provider reads the existing cluster through the AWS provider data source;
  it does not create or modify the EKS cluster itself.
- Argo CD's server service remains `ClusterIP`. Start with local port-forward access
  and decide on secure external access separately.
- After apply, connect with `kubectl port-forward -n argocd svc/argocd-server 8080:443`
  and open `https://localhost:8080`.
- Retrieve the initial admin password with
  `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo`
  and change it after signing in.
- This folder does not install Prometheus or Grafana. Add monitoring only when the
  GitOps workflow is established and the project is ready for the observability phase.
