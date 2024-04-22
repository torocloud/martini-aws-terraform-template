// General configuration
variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
}

variable "name_suffix" {
  description = "Suffix to add to the resources' names"
  default     = ""
  type        = string
}

variable "tags" {
  description = "Common tags for components created in the infrastructure"
  type        = map(string)

  default = {
    Application = "Martini"
    Repository  = "https://github.com/torocloud/martini-aws-terraform-template"
  }
}

// Application configuration
variable "martini_workspace_license" {
  description = "Full license text to be used with Martini"
  type        = string
}

variable "martini_workspace_cpu" {
  description = "Amount of CPU units that should be assigned to the Martini application"
  type        = number
}

variable "martini_workspace_memory" {
  description = "Amount of memory (in MBs) that should be assigned to the Martini application"
  type        = number
}

variable "martini_workspace_mysql_driver_version" {
  description = "Version of the MySQL driver that should be automatically installed on Martini"
  type        = string
  default     = "8.3.0"
}

variable "martini_workspace_postgres_driver_version" {
  description = "Version of the PostgreSQL driver that should be automatically installed on Martini"
  type        = string
  default     = "42.7.1"
}

// ECS configuration
variable "ecs_asg_instance_ami_filter" {
  description = "Name filter for the ECS ASG AMI. Valid only if `ecs_capacity_provider_type` is set to `EC2`"
  type        = string
  default     = null
}

variable "ecs_asg_instance_type" {
  description = "Instance type to use for the underlying instances. Valid only if `ecs_capacity_provider_type` is set to `EC2`"
  type        = string
  default     = null
}

variable "ecs_asg_max_size" {
  description = "A maximum size for the AutoScaling Group that handles the ECS cluster. Valid only if `ecs_capacity_provider_type` is set to `EC2`"
  type        = number
  default     = 1
}

variable "ecs_capacity_provider_type" {
  description = "A type of a capacity provider that should be used by the ECS cluster"
  type        = string

  validation {
    condition     = contains(["FARGATE", "EC2"], var.ecs_capacity_provider_type)
    error_message = "The capacity provider's type can only be `FARGATE` or `EC2`"
  }
}

variable "ecs_docker_image_url" {
  description = "An URL to the Docker image used by the application"
  type        = string
  default     = "toroio/martini-runtime:latest"
}

// Logs configuration
variable "logs_retention_in_days" {
  description = "Retention (in days) for ECS related Cloudwatch Logs"
  type        = number
  default     = 30
}

// Dependencies
// AmazonMQ configuration
variable "enable_amazonmq" {
  description = "Should Martini use Amazon MQ message broker?"
  type        = bool
  default     = false
}

variable "amazonmq_instance_class" {
  description = "Instance class for the Amazon MQ cluster. Valid only if `enable_amazonmq` is set to `true`"
  type        = string
  default     = null
}

variable "amazonmq_instance_version" {
  description = "Instance version for the Amazon MQ cluster. Valid only if `enable_amazonmq` is set to `true`"
  type        = string
  default     = null
}

variable "amazonmq_password" {
  description = "Password to set in the Amazon MQ cluster. Valid only if `enable_amazonmq` is set to `true`"
  type        = string
  default     = null
}

variable "amazonmq_username" {
  description = "Username to set in the Amazon MQ cluster. Valid only if `enable_amazonmq` is set to `true`"
  type        = string
  default     = null
}

// KMS configuration
variable "kms_deletion_window_in_days" {
  description = "A window for KMS keys to get deleted, in days"
  type        = number
  default     = 30
}

// RDS configuration
variable "enable_rds" {
  description = "Should Martini use RDS database?"
  type        = bool
  default     = false
}

variable "rds_allocated_storage" {
  description = "An amount of GBs to allocate to the RDS instance. Valid only if `enable_rds` is set to `true`"
  type        = number
  default     = 8
}

variable "rds_database_name" {
  description = "Name of the RDS database. Valid only if `enable_rds` is set to `true`"
  type        = string
  default     = "martini"
}

variable "rds_engine_type" {
  description = "The RDS engine type to use. Can be either `mysql` or `postgres`. Valid only if `enable_rds` is set to `true`"
  type        = string
  default     = null

  validation {
    condition     = var.rds_engine_type == null ? true : contains(["mysql", "postgres"], var.rds_engine_type)
    error_message = "The RDS engine type has to be either 'mysql' or 'postgres'"
  }
}

variable "rds_engine_version" {
  description = "The RDS engine version to use. Valid only if `enable_rds` is set to `true`"
  type        = string
  default     = null
}

variable "rds_instance_class" {
  description = "An instance class to use by the RDS instance. Valid only if `enable_rds` is set to `true`"
  type        = string
  default     = "db.t4g.medium"
}

variable "rds_username" {
  description = "Username to set in the RDS instance. Valid only if `enable_rds` is set to `true`"
  type        = string
  default     = null
}

// SQS configuration
variable "enable_sqs" {
  description = "Should Martini use SQS message broker?"
  type        = bool
  default     = false
}