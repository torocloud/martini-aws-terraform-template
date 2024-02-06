module "server_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.1.0"

  name        = "${local.name_prefix}-ecs-sg"
  description = "Security group for ${local.name_prefix} ECS"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      rule                     = "all-tcp",
      source_security_group_id = module.alb_sg.security_group_id
    }
  ]
  egress_rules = ["all-all"]

  tags = {
    Service = "ECS"
  }
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "task_role" {
  name = "${local.ecs_service_name}-task"

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_cloudwatch_log_group" "logs" {
  name       = "${local.name_prefix}-ecs"
  kms_key_id = module.logs_kms.key_arn

  retention_in_days = var.logs_retention_in_days
}

resource "aws_iam_role" "task_execution_role" {
  name = "${local.ecs_service_name}-task-execution"

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy" "task_execution_role_policy" {
  name   = "${local.ecs_service_name}-ecr-logs-ssm"
  role   = aws_iam_role.task_execution_role.id
  policy = data.aws_iam_policy_document.ecs_exec_policy.json
}

data "aws_iam_policy_document" "ecs_exec_policy" {
  #checkov:skip=CKV_AWS_356:ECR permissions can't be limited

  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:*:*:log-group:${aws_cloudwatch_log_group.logs.name}:log-stream:*",
      "arn:aws:logs:*:*:log-group:${aws_cloudwatch_log_group.logs.name}"
    ]
  }

  statement {
    effect    = "Allow"
    resources = [aws_ssm_parameter.license.arn]
    actions   = ["ssm:GetParameter*"]
  }

  statement {
    effect    = "Allow"
    resources = [module.ssm_kms.key_arn]
    actions   = ["kms:Decrypt"]
  }
}

resource "aws_ssm_parameter" "license" {
  name = "${local.parameter_store_prefix}/MARTINI/LICENSE"

  key_id = module.ssm_kms.key_arn
  tier   = "Advanced"
  type   = "SecureString"
  value  = var.martini_workspace_license
}

resource "aws_ecs_task_definition" "martini" {
  cpu    = var.martini_workspace_cpu
  memory = var.martini_workspace_memory

  family                   = local.ecs_service_name
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  network_mode             = local.is_ecs_fargate ? "awsvpc" : "bridge"
  requires_compatibilities = [var.ecs_capacity_provider_type]
  task_role_arn            = aws_iam_role.task_role.arn

  container_definitions = jsonencode([
    {
      name = "bash"
      image = "bash:5"
      memoryReservation = 256
      essential = false
      command = [
        "-c",
        "wget ${local.jdbc_postgres_download_url} -P /lib-ext/ && wget ${local.jdbc_mysql_download_url} -P /lib-ext/"
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.logs.name
          "awslogs-region"        = data.aws_region.current.id
          "awslogs-stream-prefix" = "${local.name_prefix}-bash"
        }
      }
      mountPoints = [{
        sourceVolume = "lib-ext"
        containerPath = "/lib-ext"
      }]
    }, {
      dependsOn = [{
        containerName = "bash"
        condition = "COMPLETE"
      }]

      name              = local.ecs_service_name
      image             = var.ecs_docker_image_url
      memoryReservation = var.martini_workspace_memory - 256
      essential         = true
      privileged        = false
      command           = []
      environment = [
        {
          name : "JAVA_OPTS_EXT"
          value : "-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0"
        }
      ]
      secrets = [
        {
          name      = "MR_LICENSE"
          valueFrom = aws_ssm_parameter.license.arn
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.logs.name
          "awslogs-region"        = data.aws_region.current.id
          "awslogs-stream-prefix" = local.name_prefix
        }
      }
      mountPoints = [{
        sourceVolume = "lib-ext"
        containerPath = "/data/lib/ext"
      }]
      portMappings = [
        {
          containerPort = local.ecs_container_port
          protocol      = "tcp"
        }
      ]
    }
  ])

  volume {
    name = "lib-ext"
  }
}

resource "aws_ecs_cluster" "martini" {
  name = local.ecs_cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Service = "ECS"
  }
}

resource "aws_ecs_service" "martini" {
  depends_on = [module.server_sg]

  name = local.ecs_service_name

  cluster                = aws_ecs_cluster.martini.name
  desired_count          = 1
  enable_execute_command = false
  launch_type            = local.is_ecs_fargate ? "FARGATE" : null
  task_definition        = aws_ecs_task_definition.martini.arn

  load_balancer {
    container_name   = local.ecs_service_name
    container_port   = local.ecs_container_port
    target_group_arn = module.alb.target_groups["ecs-service"].arn
  }

  dynamic "capacity_provider_strategy" {
    for_each = !local.is_ecs_fargate ? [1] : []

    content {
      capacity_provider = aws_ecs_capacity_provider.martini["ecs"].name
      base              = 0
      weight            = 1
    }
  }

  dynamic "network_configuration" {
    for_each = local.is_ecs_fargate ? [1] : []

    content {
      security_groups = [module.server_sg.security_group_id]
      subnets         = module.vpc.private_subnets
    }
  }
}

resource "aws_ecs_capacity_provider" "martini" {
  for_each = local.is_ecs_fargate ? [] : toset(["ecs"])

  name = "${local.name_prefix}-ecs-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = module.ecs_asg.autoscaling_group_arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      maximum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
  }

  tags = {
    Service = "ECS"
  }
}

resource "aws_ecs_cluster_capacity_providers" "martini" {
  for_each = local.is_ecs_fargate ? [] : toset(["ecs"])

  capacity_providers = [aws_ecs_capacity_provider.martini["ecs"].name]
  cluster_name       = local.ecs_cluster_name

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.martini["ecs"].name
    weight            = 1
  }
}