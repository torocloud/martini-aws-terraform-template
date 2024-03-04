module "amazonmq_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.1.0"

  create = var.enable_amazonmq

  name        = "${local.name_prefix}-amazonmq-sg"
  description = "Security group for ${local.name_prefix} AmazonMQ"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      rule                     = "activemq-5671-tcp",
      source_security_group_id = module.server_sg.security_group_id
      }, {
      rule                     = "activemq-8883-tcp",
      source_security_group_id = module.server_sg.security_group_id
      }, {
      rule                     = "activemq-61614-tcp",
      source_security_group_id = module.server_sg.security_group_id
      }, {
      rule                     = "activemq-61617-tcp",
      source_security_group_id = module.server_sg.security_group_id
      }, {
      rule                     = "activemq-61619-tcp",
      source_security_group_id = module.server_sg.security_group_id
    }
  ]
  egress_rules = ["all-all"]

  tags = {
    Service = "AmazonMQ"
  }
}

module "amazonmq" {
  source  = "cloudposse/mq-broker/aws"
  version = "~> 3.4.0"

  enabled = var.enable_amazonmq

  name = "${local.name_prefix}-mq-broker"

  apply_immediately             = false
  associated_security_group_ids = [module.amazonmq_sg.security_group_id]
  auto_minor_version_upgrade    = true
  create_security_group         = false
  deployment_mode               = "ACTIVE_STANDBY_MULTI_AZ"
  engine_type                   = "ActiveMQ"
  engine_version                = var.amazonmq_instance_version
  ssm_parameter_name_format     = "${local.parameter_store_prefix}/%s/%s"
  ssm_path                      = "AMAZONMQ"

  audit_log_enabled   = true
  general_log_enabled = true
  encryption_enabled  = true
  use_aws_owned_key   = false

  host_instance_type = var.amazonmq_instance_class
  kms_mq_key_arn     = module.amazonmq_kms.key_arn
  mq_admin_user      = [var.amazonmq_username]
  mq_admin_password  = [var.amazonmq_password]
  subnet_ids         = module.vpc.private_subnets
  vpc_id             = module.vpc.vpc_id

  tags = {
    Service = "AmazonMQ"
  }
}