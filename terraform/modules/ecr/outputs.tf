# Frontend outputs
output "frontend_repository_name" {
  description = "Name of the repository"
  value       = module.ecr_frontend.repository_name
}

output "frontend_repository_arn" {
  description = "Full ARN of the repository"
  value       = module.ecr_frontend.repository_arn
}

output "frontend_repository_registry_id" {
  description = "The registry ID where the repository was created"
  value       = module.ecr_frontend.repository_registry_id
}

output "frontend_repository_url" {
  description = "The URL of the repository (in the form `aws_account_id.dkr.ecr_frontend.region.amazonaws.com/repositoryName`)"
  value       = module.ecr_frontend.repository_url
}

# Backend outputs
output "backend_repository_name" {
  description = "Name of the repository"
  value       = module.ecr_backend.repository_name
}

output "backend_repository_arn" {
  description = "Full ARN of the repository"
  value       = module.ecr_backend.repository_arn
}

output "backend_repository_registry_id" {
  description = "The registry ID where the repository was created"
  value       = module.ecr_backend.repository_registry_id
}

output "backend_repository_url" {
  description = "The URL of the repository (in the form `aws_account_id.dkr.ecr_backend.region.amazonaws.com/repositoryName`)"
  value       = module.ecr_backend.repository_url
}
