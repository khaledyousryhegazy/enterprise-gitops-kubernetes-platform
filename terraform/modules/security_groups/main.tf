# ALB security group
module "alb_security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.name_prefix}-ALB-sg"
  description = "security group for application load balancer"
  vpc_id      = var.vpc_id

  ingress_rules = {
    alb-https = {
      from_port   = 443
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
    alb-http = {
      from_port   = 80
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
    self-all = {
      ip_protocol                  = "-1"
      referenced_security_group_id = "self"
      description                  = "All traffic from members of this SG"
    }
  }

  egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  tags = var.tags
}

#=======================================================================#
# EKS security group

module "eks_security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.name_prefix}-EKS-sg"
  description = "security group for EKS"
  vpc_id      = var.vpc_id

  ingress_rules = {
    eks-from-alb = {
      from_port                    = 8080
      to_port                      = 8080
      ip_protocol                  = "tcp"
      referenced_security_group_id = module.alb_security_group.id
    }

    self-all = {
      ip_protocol                  = "-1"
      referenced_security_group_id = "self"
      description                  = "All traffic from members of this SG"
    }
  }

  egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  tags = var.tags
}

#=======================================================================#
# RDS security group

module "rds_security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.name_prefix}-RDS-sg"
  description = "security group for RDS"
  vpc_id      = var.vpc_id

  ingress_rules = {
    rds-from-eks = {
      from_port                    = 5432
      to_port                      = 5432
      ip_protocol                  = "tcp"
      referenced_security_group_id = module.eks_security_group.id
    }
  }

  egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  tags = var.tags
}

#=======================================================================#
# Redis security group

module "redis_security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.name_prefix}-redis-sg"
  description = "security group for Redis"
  vpc_id      = var.vpc_id

  ingress_rules = {
    redis-from-eks = {
      from_port                    = 6379
      to_port                      = 6379
      ip_protocol                  = "tcp"
      referenced_security_group_id = module.eks_security_group.id
    }
  }

  egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  tags = var.tags
}
