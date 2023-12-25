module "alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.1.0"

  name        = "${local.name_prefix}-alb-sg"
  description = "Security group for the main ALB"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      rule        = "http-80-tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_rules = ["all-all"]

  tags = {
    Service = "ALB"
  }
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.4.0"

  name = "${local.name_prefix}-alb"

  create_security_group      = false
  enable_deletion_protection = false
  security_groups            = [module.alb_sg.security_group_id]
  subnets                    = module.vpc.public_subnets
  vpc_id                     = module.vpc.vpc_id

  listeners = {
    http = {
      port        = 80
      protocol    = "HTTP"
      action_type = "forward"

      forward = {
        target_group_key = "ecs-service"
      }
    }
  }

  target_groups = {
    ecs-service = {
      create_attachment = false
      name_prefix       = "mart"
      protocol          = "HTTP"
      target_type       = local.is_ecs_fargate ? "ip" : "instance"

      health_check = {
        enabled = true
        path    = "/public/metadata/version"
        port    = "traffic-port"
      }
    }
  }

  tags = {
    Service = "ALB"
  }
}