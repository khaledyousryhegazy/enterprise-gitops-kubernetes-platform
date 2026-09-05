# ============================================================
# VPC
# ============================================================
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "database_subnets" {
  value = module.vpc.database_subnets
}

# ============================================================
# EKS
# ============================================================
output "cluster_name" {
  value = module.eks_cluster.cluster_name
}

output "cluster_endpoint" {
  value = module.eks_cluster.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value     = module.eks_cluster.cluster_certificate_authority_data
  sensitive = true
}

output "oidc_provider_arn" {
  value = module.eks_cluster.oidc_provider_arn
}

output "node_security_group_id" {
  value = module.eks_cluster.node_security_group_id
}

# ============================================================
# IAM Roles
# ============================================================
output "eks_cluster_role_arn" {
  value = module.iam.eks_cluster_role_arn
}

output "eks_node_role_arn" {
  value = module.iam.eks_node_role_arn
}

output "vpc_cni_role_arn" {
  value = module.iam.vpc_cni_role_arn
}

output "ebs_csi_role_arn" {
  value = module.iam.ebs_csi_role_arn
}

output "aws_lb_controller_role_arn" {
  value = module.iam.aws_lb_controller_role_arn
}

output "external_dns_role_arn" {
  value = module.iam.external_dns_role_arn
}

output "github_actions_role_arn" {
  value = module.iam.github_actions_role_arn
}

# ============================================================
# KMS
# ============================================================
output "kms_key_arn" {
  value = module.kms.key_arn
}

output "kms_key_id" {
  value = module.kms.key_id
}

# ============================================================
# RDS
# ============================================================
output "rds_endpoint" {
  value = module.rds_db.db_instance_endpoint
}

output "rds_address" {
  value = module.rds_db.db_instance_address
}

output "rds_master_user_secret_arn" {
  value = module.rds_db.rds_master_user_secret_arn
}

# ============================================================
# ElastiCache Redis
# ============================================================
output "redis_primary_endpoint" {
  value = module.redis.redis_primary_endpoint
}

output "redis_reader_endpoint" {
  value = module.redis.redis_reader_endpoint
}

output "redis_auth_token" {
  value     = module.redis.redis_auth_token
  sensitive = true
}

# ============================================================
# ECR
# ============================================================
output "ecr_backend_repository_url" {
  value = module.ecr.backend_repository_url
}
output "ecr_frontend_repository_url" {
  value = module.ecr.frontend_repository_url
}

# ============================================================
# Security Groups
# ============================================================
output "alb_security_group_id" {
  value = module.security_groups.alb_security_group_id
}

output "rds_security_group_id" {
  value = module.security_groups.rds_security_group_id
}

output "redis_security_group_id" {
  value = module.security_groups.redis_security_group_id
}

# ============================================================
# CloudWatch / SNS
# ============================================================
output "sns_topic_arn" {
  value = module.cloudwatch.sns_topic_arn
}

output "cloudwatch_log_group_name" {
  value = module.cloudwatch.cloudwatch_log_group_name
}
