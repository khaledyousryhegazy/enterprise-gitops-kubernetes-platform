module "redis" {
  source = "terraform-aws-modules/elasticache/aws"

  replication_group_id = "${var.name_prefix}-replica-group"

  engine_version = "7.1"
  node_type      = "cache.t3.micro"

  transit_encryption_enabled = true
  auth_token                 = random_password.redis_auth.result
  maintenance_window         = "sun:05:00-sun:09:00"
  apply_immediately          = false

  vpc_id             = var.vpc_id
  security_group_ids = [var.security_group_id]

  subnet_group_name        = "${var.name_prefix}-subnet-group"
  subnet_group_description = "${title(var.name_prefix)} subnet group"
  subnet_ids               = var.private_subnets

  num_cache_clusters         = 2
  automatic_failover_enabled = true
  multi_az_enabled           = true
  at_rest_encryption_enabled = true

  snapshot_retention_limit = 7
  snapshot_window          = "03:00-04:00"

  create_parameter_group      = true
  parameter_group_name        = "${var.name_prefix}-parameter-group"
  parameter_group_family      = "redis7"
  parameter_group_description = "${title(var.name_prefix)} parameter group"
  parameters = [
    {
      name  = "latency-tracking"
      value = "yes"
    }
  ]

  tags = var.tags
}

resource "random_password" "redis_auth" {
  length  = 32
  special = false
}
