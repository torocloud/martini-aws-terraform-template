// Load balancer's DNS name
output "alb_dns_name" {
  value = module.alb.dns_name
}

// Load balancer listener's ARN
output "alb_http_listener_arn" {
  value = module.alb.listeners["http"].arn
}

// Load balancer target group's ARN
output "alb_target_group_arn" {
  value = module.alb.target_groups["ecs-service"].arn
}

// Load balancer security group's ID
output "alb_security_group_id" {
  value = module.alb_sg.security_group_id
}

// AmazonMQ SSL endpoint
output "amazonmq_ssl_endpoint" {
  value = module.amazonmq.primary_ssl_endpoint
}

// AmazonMQ MQTT SSL endpoint
output "amazonmq_mqtt_endpoint" {
  value = module.amazonmq.primary_mqtt_ssl_endpoint
}

// AmazonMQ AMQP SSL endpoint
output "amazonmq_amqp_endpoint" {
  value = module.amazonmq.primary_amqp_ssl_endpoint
}

// AmazonMQ security group's ID
output "amazonmq_security_group_id" {
  value = module.amazonmq_sg.security_group_id
}

// AMI ID used for instances in ECS cluster if `ecs_capacity_provider_type` is set to `EC2`
output "asg_ami_id" {
  value = local.is_ecs_fargate ? null : data.aws_ami.asg_ami.id
}

// ARN of the Autoscaling group if `ecs_capacity_provider_type` is set to `EC2`
output "asg_arn" {
  value = local.is_ecs_fargate ? null : module.ecs_asg.autoscaling_group_arn
}

// ECS cluster's name
output "ecs_cluster_name" {
  value = aws_ecs_cluster.martini.name
}

// ECS service's name
output "ecs_service_name" {
  value = aws_ecs_service.martini.name
}

// Cloudwatch Logs group's ARN used by the ECS service
output "ecs_log_group_arn" {
  value = aws_cloudwatch_log_group.logs.arn
}

// Cloudwatch Logs group's name used by the ECS service
output "ecs_log_group_name" {
  value = aws_cloudwatch_log_group.logs.name
}

// Martini task definition's ARN
output "ecs_task_definition_arn" {
  value = aws_ecs_task_definition.martini.arn
}

// Server's security group
output "ecs_security_group_id" {
  value = module.server_sg.security_group_id
}

// AmazonMQ KMS ARN
output "kms_amazonmq_arn" {
  value = module.amazonmq_kms.key_arn
}

// Cloudwatch Logs KMS ARN
output "kms_logs_arn" {
  value = module.logs_kms.key_arn
}

// RDS KMS ARN
output "kms_rds_arn" {
  value = module.rds_kms.key_arn
}

// SQS KMS ARN
output "kms_sqs_arn" {
  value = module.sqs_kms.key_arn
}

// SSM KMS ARN
output "kms_ssm_arn" {
  value = module.ssm_kms.key_arn
}

// RDS database's endpoint
output "rds_endpoint" {
  value = module.rds.db_instance_endpoint
}

// RDS parameter group's ARN
output "rds_parameter_group_arn" {
  value = module.rds.db_parameter_group_arn
}

// RDS password's Secrets Manager ARN
output "rds_password_arn" {
  value = module.rds.db_instance_master_user_secret_arn
}

// RDS subnet group's ARN
output "rds_subnet_group_arn" {
  value = module.rds.db_subnet_group_arn
}

// RDS security group's ID
output "rds_security_group_id" {
  value = module.rds_sg.security_group_id
}

// SQS ARN
output "sqs_arn" {
  value = module.sqs.queue_arn
}

//VPC ID
output "vpc_id" {
  value = module.vpc.vpc_id
}

// A list of VPC private subnet IDs
output "vpc_private_subnets" {
  value = module.vpc.private_subnets
}

// A list of VPC public subnet IDs
output "vpc_public_subnets" {
  value = module.vpc.public_subnets
}