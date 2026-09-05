output "redis_primary_endpoint" {
  value = module.redis.replication_group_primary_endpoint_address
}

output "redis_reader_endpoint" {
  value = module.redis.replication_group_reader_endpoint_address
}

output "redis_port" {
  value = module.redis.replication_group_port
}

output "redis_replication_group_id" {
  value = module.redis.replication_group_id
}

output "redis_security_group_id" {
  value = module.redis.security_group_id
}

output "redis_auth_token" {
  value     = random_password.redis_auth.result
  sensitive = true
}