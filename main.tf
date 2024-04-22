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
  name_prefix            = "${terraform.workspace}-martini${var.name_suffix}"
  parameter_store_prefix = "/${terraform.workspace}/MARTINI"
  ecs_cluster_name       = "${local.name_prefix}Cluster"
  ecs_container_port     = 8080
  ecs_service_name       = "${local.name_prefix}-service"

  jdbc_mysql_download_url = "https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/${var.martini_workspace_mysql_driver_version}/mysql-connector-j-${var.martini_workspace_mysql_driver_version}.jar"
  jdbc_postgres_download_url = "https://github.com/pgjdbc/pgjdbc/releases/download/REL${var.martini_workspace_postgres_driver_version}/postgresql-${var.martini_workspace_postgres_driver_version}.jar"
}