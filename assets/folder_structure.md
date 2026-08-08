terraform/
├── backend.hcl
├── environments/
│ ├── dev/
│ │ ├── backend.hcl
│ │ ├── main.tf
│ │ ├── variables.tf
│ │ └── terraform.tfvars
│ └── prod/
│ ├── backend.hcl
│ ├── main.tf
│ ├── variables.tf
│ └── terraform.tfvars
├── modules/
│ ├── vpc/
│ ├── eks/
│ ├── ecr/
│ ├── iam/
│ ├── route53/
│ ├── acm/
│ └── security-groups/
├── versions.tf
├── providers.tf
├── variables.tf
├── outputs.tf
└── README.md
