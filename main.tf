terraform {
  required_version = ">= 1.5.0, < 2.0.0"

  required_providers {
    aws = {
      version = "~> 5"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = merge(var.tags, {
      Environment = tostring(terraform.workspace)
    })
  }
}

locals {
  is_ecs_fargate         = var.ecs_capacity_provider_type == "FARGATE"
  name_prefix            = "${terraform.workspace}-martini"
  parameter_store_prefix = "/${terraform.workspace}/MARTINI"
  ecs_cluster_name       = "${local.name_prefix}Cluster"
  ecs_container_port     = 8080
  ecs_service_name       = "${local.name_prefix}-service"
}