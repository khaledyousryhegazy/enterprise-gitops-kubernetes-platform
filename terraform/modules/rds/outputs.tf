output "db_identifier" {
  description = "RDS instance ID"
  value       = module.db.db_instance_identifier
}

output "db_instance_arn" {
  description = "RDS instance ARN"
  value       = module.db.db_instance_arn
}

output "db_instance_endpoint" {
  description = "RDS endpoint"
  value       = module.db.db_instance_endpoint
}

output "db_instance_address" {
  description = "RDS hostname"
  value       = module.db.db_instance_address
}

output "db_instance_port" {
  description = "RDS port"
  value       = module.db.db_instance_port
}

output "db_instance_name" {
  description = "Database name"
  value       = module.db.db_instance_name
}

output "db_subnet_group_id" {
  description = "DB subnet group name"
  value       = module.db.db_subnet_group_id
}