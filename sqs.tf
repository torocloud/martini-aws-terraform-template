module "sqs" {
  source  = "terraform-aws-modules/sqs/aws"
  version = "~> 4.2.0"

  create = var.enable_sqs

  name = "${local.name_prefix}-sqs"

  kms_master_key_id                 = module.sqs_kms.key_arn
  kms_data_key_reuse_period_seconds = 300

  tags = {
    Service = "SQS"
  }
}

data "aws_iam_policy_document" "ecs_sqs_policy" {
  for_each = var.enable_sqs ? toset(["ecs_sqs"]) : []

  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt"
    ]
    resources = [module.sqs_kms.key_arn]
  }

  statement {
    effect = "Allow"
    actions = [
      "sqs:ReceiveMessage"
    ]
    resources = [module.sqs.queue_arn]
  }
}

resource "aws_iam_role_policy" "ecs_sqs_role_policy" {
  for_each = var.enable_sqs ? toset(["ecs_sqs"]) : []

  name   = "${local.ecs_service_name}-sqs-access"
  role   = aws_iam_role.task_role.id
  policy = data.aws_iam_policy_document.ecs_sqs_policy["ecs_sqs"].json
}