output "alb_security_group_id" {
  description = "Security Group ID for the ALB"
  value       = module.alb_security_group.id
}

output "rds_security_group_id" {
  description = "Security Group ID for RDS"
  value       = module.rds_security_group.id
}

output "redis_security_group_id" {
  description = "Security Group ID for Redis"
  value       = module.redis_security_group.id
}
