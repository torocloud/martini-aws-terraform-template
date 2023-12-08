aws_region = "us-east-1"

martini_workspace_cpu    = 1024
martini_workspace_memory = 4096

ecs_asg_instance_ami_filter = "al2023-ami-ecs-hvm-2023.0.*-x86_64"
ecs_asg_instance_type       = "t3.large"
ecs_capacity_provider_type  = "FARGATE"