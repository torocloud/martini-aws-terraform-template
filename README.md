# Martini Terraform template

The repository contains a Terraform template to create a complete infrastructure running Martini Runtime in the cloud 
on AWS ECS along with optional dependencies such as an RDS database, an AmazonMQ broker or an SQS broker.

**Note:** This template downloads required JDBC drivers automatically, but Martini doesn't embed the drivers by default

# Requirements

The template requires an installed Terraform with version 1.6.0 or higher. In order to install the Terraform, please 
use instructions from [the Terraform site](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

The template also assumes that you have an existing AWS account and credentials for using the account installed locally.
In order to install the credentials locally, please use instructions from [the AWS site](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)

# How to use this template

In order to deploy the environment to the cloud, please run following commands:

- `terraform init`
- `terraform apply -var-file=example.tfvars`

# Uses external modules

The repository uses external Terraform modules in order to configure some components in the cloud. Please find the list of modules below

# Precommit checks

The template uses [pre-commit](https://github.com/antonbabenko/pre-commit-terraform#how-to-install) library in order to 
run a few checks before the commit. The checks used are (in order of execution):

- [Checkov](https://github.com/bridgecrewio/checkov)
- `terraform fmt`
- [Terraform Docs](https://github.com/terraform-docs/terraform-docs)
- `terraform validate`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.30.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb"></a> [alb](#module\_alb) | terraform-aws-modules/alb/aws | ~> 9.2.0 |
| <a name="module_alb_sg"></a> [alb\_sg](#module\_alb\_sg) | terraform-aws-modules/security-group/aws | ~> 5.1.0 |
| <a name="module_amazonmq"></a> [amazonmq](#module\_amazonmq) | cloudposse/mq-broker/aws | ~> 3.1.0 |
| <a name="module_amazonmq_kms"></a> [amazonmq\_kms](#module\_amazonmq\_kms) | terraform-aws-modules/kms/aws | ~> 2.1.0 |
| <a name="module_amazonmq_sg"></a> [amazonmq\_sg](#module\_amazonmq\_sg) | terraform-aws-modules/security-group/aws | ~> 5.1.0 |
| <a name="module_ecs_asg"></a> [ecs\_asg](#module\_ecs\_asg) | terraform-aws-modules/autoscaling/aws | ~> 7.3.1 |
| <a name="module_efs"></a> [efs](#module\_efs) | terraform-aws-modules/efs/aws | ~> 1.3.1 |
| <a name="module_efs_kms"></a> [efs\_kms](#module\_efs\_kms) | terraform-aws-modules/kms/aws | ~> 2.1.0 |
| <a name="module_efs_sg"></a> [efs\_sg](#module\_efs\_sg) | terraform-aws-modules/security-group/aws | ~> 5.1.0 |
| <a name="module_logs_kms"></a> [logs\_kms](#module\_logs\_kms) | terraform-aws-modules/kms/aws | ~> 2.1.0 |
| <a name="module_rds"></a> [rds](#module\_rds) | terraform-aws-modules/rds/aws | ~> 6.3.0 |
| <a name="module_rds_kms"></a> [rds\_kms](#module\_rds\_kms) | terraform-aws-modules/kms/aws | ~> 2.1.0 |
| <a name="module_rds_sg"></a> [rds\_sg](#module\_rds\_sg) | terraform-aws-modules/security-group/aws | ~> 5.1.0 |
| <a name="module_server_sg"></a> [server\_sg](#module\_server\_sg) | terraform-aws-modules/security-group/aws | ~> 5.1.0 |
| <a name="module_sqs"></a> [sqs](#module\_sqs) | terraform-aws-modules/sqs/aws | ~> 4.1.0 |
| <a name="module_sqs_kms"></a> [sqs\_kms](#module\_sqs\_kms) | terraform-aws-modules/kms/aws | ~> 2.1.0 |
| <a name="module_ssm_kms"></a> [ssm\_kms](#module\_ssm\_kms) | terraform-aws-modules/kms/aws | ~> 2.1.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 5.2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_capacity_provider.martini](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_capacity_provider) | resource |
| [aws_ecs_cluster.martini](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_cluster_capacity_providers.martini](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster_capacity_providers) | resource |
| [aws_ecs_service.martini](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.martini](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_role.task_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.ecs_sqs_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.task_execution_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_ssm_parameter.license](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ami.asg_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_availability_zones.azs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_exec_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_sqs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_amazonmq_instance_class"></a> [amazonmq\_instance\_class](#input\_amazonmq\_instance\_class) | Instance class for the Amazon MQ cluster. Valid only if `enable_amazonmq` is set to `true` | `string` | `null` | no |
| <a name="input_amazonmq_instance_version"></a> [amazonmq\_instance\_version](#input\_amazonmq\_instance\_version) | Instance version for the Amazon MQ cluster. Valid only if `enable_amazonmq` is set to `true` | `string` | `null` | no |
| <a name="input_amazonmq_password"></a> [amazonmq\_password](#input\_amazonmq\_password) | Password to set in the Amazon MQ cluster. Valid only if `enable_amazonmq` is set to `true` | `string` | `null` | no |
| <a name="input_amazonmq_username"></a> [amazonmq\_username](#input\_amazonmq\_username) | Username to set in the Amazon MQ cluster. Valid only if `enable_amazonmq` is set to `true` | `string` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region to deploy resources into | `string` | n/a | yes |
| <a name="input_ecs_asg_instance_ami_filter"></a> [ecs\_asg\_instance\_ami\_filter](#input\_ecs\_asg\_instance\_ami\_filter) | Name filter for the ECS ASG AMI. Valid only if `ecs_capacity_provider_type` is set to `EC2` | `string` | `null` | no |
| <a name="input_ecs_asg_instance_type"></a> [ecs\_asg\_instance\_type](#input\_ecs\_asg\_instance\_type) | Instance type to use for the underlying instances. Valid only if `ecs_capacity_provider_type` is set to `EC2` | `string` | `null` | no |
| <a name="input_ecs_asg_max_size"></a> [ecs\_asg\_max\_size](#input\_ecs\_asg\_max\_size) | A maximum size for the AutoScaling Group that handles the ECS cluster. Valid only if `ecs_capacity_provider_type` is set to `EC2` | `number` | `1` | no |
| <a name="input_ecs_capacity_provider_type"></a> [ecs\_capacity\_provider\_type](#input\_ecs\_capacity\_provider\_type) | A type of a capacity provider that should be used by the ECS cluster | `string` | n/a | yes |
| <a name="input_ecs_docker_image_url"></a> [ecs\_docker\_image\_url](#input\_ecs\_docker\_image\_url) | An URL to the Docker image used by the application | `string` | `"toroio/martini-runtime:latest"` | no |
| <a name="input_enable_amazonmq"></a> [enable\_amazonmq](#input\_enable\_amazonmq) | Should Martini use Amazon MQ message broker? | `bool` | `false` | no |
| <a name="input_enable_rds"></a> [enable\_rds](#input\_enable\_rds) | Should Martini use RDS database? | `bool` | `false` | no |
| <a name="input_enable_sqs"></a> [enable\_sqs](#input\_enable\_sqs) | Should Martini use SQS message broker? | `bool` | `false` | no |
| <a name="input_kms_deletion_window_in_days"></a> [kms\_deletion\_window\_in\_days](#input\_kms\_deletion\_window\_in\_days) | A window for KMS keys to get deleted, in days | `number` | `30` | no |
| <a name="input_logs_retention_in_days"></a> [logs\_retention\_in\_days](#input\_logs\_retention\_in\_days) | Retention (in days) for ECS related Cloudwatch Logs | `number` | `30` | no |
| <a name="input_martini_workspace_cpu"></a> [martini\_workspace\_cpu](#input\_martini\_workspace\_cpu) | Amount of CPU units that should be assigned to the Martini application | `number` | n/a | yes |
| <a name="input_martini_workspace_license"></a> [martini\_workspace\_license](#input\_martini\_workspace\_license) | Full license text to be used with Martini | `string` | n/a | yes |
| <a name="input_martini_workspace_memory"></a> [martini\_workspace\_memory](#input\_martini\_workspace\_memory) | Amount of memory (in MBs) that should be assigned to the Martini application | `number` | n/a | yes |
| <a name="input_rds_allocated_storage"></a> [rds\_allocated\_storage](#input\_rds\_allocated\_storage) | An amount of GBs to allocate to the RDS instance. Valid only if `enable_rds` is set to `true` | `number` | `8` | no |
| <a name="input_rds_database_name"></a> [rds\_database\_name](#input\_rds\_database\_name) | Name of the RDS database. Valid only if `enable_rds` is set to `true` | `string` | `"martini"` | no |
| <a name="input_rds_engine_type"></a> [rds\_engine\_type](#input\_rds\_engine\_type) | The RDS engine type to use. Can be either `mysql` or `postgres`. Valid only if `enable_rds` is set to `true` | `string` | `null` | no |
| <a name="input_rds_engine_version"></a> [rds\_engine\_version](#input\_rds\_engine\_version) | The RDS engine version to use. Valid only if `enable_rds` is set to `true` | `string` | `null` | no |
| <a name="input_rds_instance_class"></a> [rds\_instance\_class](#input\_rds\_instance\_class) | An instance class to use by the RDS instance. Valid only if `enable_rds` is set to `true` | `string` | `"db.t4g.medium"` | no |
| <a name="input_rds_username"></a> [rds\_username](#input\_rds\_username) | Username to set in the RDS instance. Valid only if `enable_rds` is set to `true` | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Common tags for components created in the infrastructure | `map(string)` | <pre>{<br>  "Application": "Martini",<br>  "Repository": "https://github.com/torocloud/martini-terraform-template"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | Load balancer's DNS name |
| <a name="output_alb_http_listener_arn"></a> [alb\_http\_listener\_arn](#output\_alb\_http\_listener\_arn) | Load balancer listener's ARN |
| <a name="output_alb_security_group_id"></a> [alb\_security\_group\_id](#output\_alb\_security\_group\_id) | Load balancer security group's ID |
| <a name="output_alb_target_group_arn"></a> [alb\_target\_group\_arn](#output\_alb\_target\_group\_arn) | Load balancer target group's ARN |
| <a name="output_amazonmq_amqp_endpoint"></a> [amazonmq\_amqp\_endpoint](#output\_amazonmq\_amqp\_endpoint) | AmazonMQ AMQP SSL endpoint |
| <a name="output_amazonmq_mqtt_endpoint"></a> [amazonmq\_mqtt\_endpoint](#output\_amazonmq\_mqtt\_endpoint) | AmazonMQ MQTT SSL endpoint |
| <a name="output_amazonmq_security_group_id"></a> [amazonmq\_security\_group\_id](#output\_amazonmq\_security\_group\_id) | AmazonMQ security group's ID |
| <a name="output_amazonmq_ssl_endpoint"></a> [amazonmq\_ssl\_endpoint](#output\_amazonmq\_ssl\_endpoint) | AmazonMQ SSL endpoint |
| <a name="output_asg_ami_id"></a> [asg\_ami\_id](#output\_asg\_ami\_id) | AMI ID used for instances in ECS cluster if `ecs_capacity_provider_type` is set to `EC2` |
| <a name="output_asg_arn"></a> [asg\_arn](#output\_asg\_arn) | ARN of the Autoscaling group if `ecs_capacity_provider_type` is set to `EC2` |
| <a name="output_ecs_cluster_name"></a> [ecs\_cluster\_name](#output\_ecs\_cluster\_name) | ECS cluster's name |
| <a name="output_ecs_log_group_arn"></a> [ecs\_log\_group\_arn](#output\_ecs\_log\_group\_arn) | Cloudwatch Logs group's ARN used by the ECS service |
| <a name="output_ecs_log_group_name"></a> [ecs\_log\_group\_name](#output\_ecs\_log\_group\_name) | Cloudwatch Logs group's name used by the ECS service |
| <a name="output_ecs_security_group_id"></a> [ecs\_security\_group\_id](#output\_ecs\_security\_group\_id) | Server's security group |
| <a name="output_ecs_service_name"></a> [ecs\_service\_name](#output\_ecs\_service\_name) | ECS service's name |
| <a name="output_ecs_task_definition_arn"></a> [ecs\_task\_definition\_arn](#output\_ecs\_task\_definition\_arn) | Martini task definition's ARN |
| <a name="output_efs_access_points"></a> [efs\_access\_points](#output\_efs\_access\_points) | EFS access points |
| <a name="output_efs_id"></a> [efs\_id](#output\_efs\_id) | EFS ID |
| <a name="output_efs_mount_targets"></a> [efs\_mount\_targets](#output\_efs\_mount\_targets) | EFS mount targets |
| <a name="output_efs_security_group_id"></a> [efs\_security\_group\_id](#output\_efs\_security\_group\_id) | EFS disk security group's ID |
| <a name="output_kms_amazonmq_arn"></a> [kms\_amazonmq\_arn](#output\_kms\_amazonmq\_arn) | AmazonMQ KMS ARN |
| <a name="output_kms_efs_arn"></a> [kms\_efs\_arn](#output\_kms\_efs\_arn) | EFS KMS ARN |
| <a name="output_kms_logs_arn"></a> [kms\_logs\_arn](#output\_kms\_logs\_arn) | Cloudwatch Logs KMS ARN |
| <a name="output_kms_rds_arn"></a> [kms\_rds\_arn](#output\_kms\_rds\_arn) | RDS KMS ARN |
| <a name="output_kms_sqs_arn"></a> [kms\_sqs\_arn](#output\_kms\_sqs\_arn) | SQS KMS ARN |
| <a name="output_kms_ssm_arn"></a> [kms\_ssm\_arn](#output\_kms\_ssm\_arn) | SSM KMS ARN |
| <a name="output_rds_endpoint"></a> [rds\_endpoint](#output\_rds\_endpoint) | RDS database's endpoint |
| <a name="output_rds_parameter_group_arn"></a> [rds\_parameter\_group\_arn](#output\_rds\_parameter\_group\_arn) | RDS parameter group's ARN |
| <a name="output_rds_password_arn"></a> [rds\_password\_arn](#output\_rds\_password\_arn) | RDS password's Secrets Manager ARN |
| <a name="output_rds_security_group_id"></a> [rds\_security\_group\_id](#output\_rds\_security\_group\_id) | RDS security group's ID |
| <a name="output_rds_subnet_group_arn"></a> [rds\_subnet\_group\_arn](#output\_rds\_subnet\_group\_arn) | RDS subnet group's ARN |
| <a name="output_sqs_arn"></a> [sqs\_arn](#output\_sqs\_arn) | SQS ARN |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC ID |
| <a name="output_vpc_private_subnets"></a> [vpc\_private\_subnets](#output\_vpc\_private\_subnets) | A list of VPC private subnet IDs |
| <a name="output_vpc_public_subnets"></a> [vpc\_public\_subnets](#output\_vpc\_public\_subnets) | A list of VPC public subnet IDs |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->