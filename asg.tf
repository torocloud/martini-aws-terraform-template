data "aws_ami" "asg_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = [var.ecs_asg_instance_ami_filter]
  }
}

module "ecs_asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 7.3.1"

  create = !local.is_ecs_fargate

  name = "${local.name_prefix}-ecs"

  create_iam_instance_profile = !local.is_ecs_fargate
  create_schedule             = false
  desired_capacity            = 0
  health_check_type           = "ELB"
  iam_instance_profile_name   = "${local.name_prefix}-ecs-instance-profile"
  iam_role_policies = {
    AmazonEC2ContainerServiceforEC2Role = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  }
  iam_role_use_name_prefix        = false
  ignore_desired_capacity_changes = true
  instance_type                   = var.ecs_asg_instance_type
  image_id                        = data.aws_ami.asg_ami.id
  max_size                        = var.ecs_asg_max_size
  min_size                        = 0
  protect_from_scale_in           = true
  security_groups                 = [module.server_sg.security_group_id]
  vpc_zone_identifier             = module.vpc.private_subnets
  target_group_arns               = [module.alb.target_groups["ecs-service"].arn]
  user_data = base64encode(templatefile("${path.module}/userdata.tpl.sh", {
    cluster_name = local.ecs_cluster_name
  }))

  tags = {
    AmazonECSManaged = true
    Service          = "AutoScaling"
  }
}