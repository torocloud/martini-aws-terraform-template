locals {
  rds_port                = var.rds_engine_type == "mysql" ? 3306 : 5432
  rds_security_group_rule = var.rds_engine_type == "mysql" ? "mysql" : "postgresql"
}

module "rds_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.1.0"

  create = var.enable_rds

  name        = "${local.name_prefix}-rds-sg"
  description = "Security group for ${local.name_prefix} RDS"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      rule                     = "${local.rds_security_group_rule}-tcp",
      source_security_group_id = module.server_sg.security_group_id
    }
  ]

  tags = {
    Service = "RDS"
  }
}

module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 6.5.1"

  identifier = "${local.name_prefix}-rds"

  allocated_storage         = var.rds_allocated_storage
  ca_cert_identifier        = "rds-ca-rsa2048-g1"
  create_db_option_group    = var.enable_rds
  create_db_instance        = var.enable_rds
  create_db_parameter_group = var.enable_rds
  create_db_subnet_group    = var.enable_rds
  engine                    = var.rds_engine_type
  engine_version            = var.rds_engine_version
  family                    = try("${var.rds_engine_type}${var.rds_engine_version}", "")
  instance_class            = var.rds_instance_class
  kms_key_id                = module.rds_kms.key_arn
  major_engine_version      = var.rds_engine_version
  skip_final_snapshot       = true

  subnet_ids             = module.vpc.private_subnets
  vpc_security_group_ids = [module.rds_sg.security_group_id]

  db_name  = var.rds_database_name
  username = var.rds_username
  port     = local.rds_port

  tags = {
    Service = "RDS"
  }
}