module "amazonmq_kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 2.1.0"

  create = var.enable_amazonmq

  aliases                 = ["alias/${local.name_prefix}-amazonmq"]
  deletion_window_in_days = var.kms_deletion_window_in_days
  description             = "A key used for encrypting Martini Amazon MQ"

  tags = {
    Service = "AmazonMQ"
  }
}

module "efs_kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 2.1.0"

  aliases                 = ["alias/${local.name_prefix}-efs"]
  deletion_window_in_days = var.kms_deletion_window_in_days
  description             = "A key used for encrypting Martini EFS file system"

  key_statements = [{
    actions = [
      "kms:CreateGrant",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
    ]
    effect    = "Allow"
    resources = ["*"]

    principals = [{
      identifiers = ["elasticfilesystem.amazonaws.com"]
      type        = "Service"
    }]
  }]

  tags = {
    Service = "EFS"
  }
}

module "logs_kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 2.1.0"

  aliases                 = ["alias/${local.name_prefix}-logs"]
  deletion_window_in_days = var.kms_deletion_window_in_days
  description             = "A key used for encrypting Martini CloudWatch Logs groups"

  key_statements = [{
    actions = [
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
    ]
    effect    = "Allow"
    resources = ["*"]

    principals = [{
      identifiers = ["logs.amazonaws.com"]
      type        = "Service"
    }]
  }]

  tags = {
    Service = "CloudWatch Logs"
  }
}

module "rds_kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 2.1.0"

  create = var.enable_rds

  aliases                 = ["alias/${local.name_prefix}-mysql"]
  deletion_window_in_days = var.kms_deletion_window_in_days
  description             = "A key used for encrypting RDS cluster"

  tags = {
    Service = "RDS"
  }
}

module "sqs_kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 2.1.0"

  create = var.enable_sqs

  aliases                 = ["alias/${local.name_prefix}-sqs"]
  deletion_window_in_days = var.kms_deletion_window_in_days
  description             = "A key used for encrypting SQS queue"

  key_statements = [{
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey",
    ]
    effect    = "Allow"
    resources = ["*"]

    principals = [{
      identifiers = ["sqs.amazonaws.com"]
      type        = "Service"
    }]
  }]

  tags = {
    Service = "SQS"
  }
}

module "ssm_kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 2.1.0"

  aliases                 = ["alias/${local.name_prefix}-ssm"]
  deletion_window_in_days = var.kms_deletion_window_in_days
  description             = "A key used for encrypting SSM parameters"

  tags = {
    Service = "SSM PS"
  }
}