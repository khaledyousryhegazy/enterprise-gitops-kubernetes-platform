module "db" {
  source     = "terraform-aws-modules/rds/aws"
  identifier = "${var.name_prefix}-rds"

  engine                   = "postgres"
  engine_version           = "17"
  engine_lifecycle_support = "open-source-rds-extended-support-disabled"
  family                   = "postgres17"
  major_engine_version     = "17"
  instance_class           = "db.t4g.micro"

  allocated_storage     = 20
  max_allocated_storage = 100

  db_name  = "${var.name_prefix}-db"
  username = "postgres"
  port     = 5432

  multi_az               = true
  create_db_subnet_group = true
  subnet_ids             = var.database_subnets
  vpc_security_group_ids = var.db_security_group_id

  storage_encrypted = true
  kms_key_id        = var.kms_key_arn

  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  create_cloudwatch_log_group     = true

  backup_retention_period = 1
  skip_final_snapshot     = true
  deletion_protection     = false # for env dev cause sometimes i terraform destroy, to making destroy easy from cli

  manage_master_user_password = true

  tags = var.tags
}
