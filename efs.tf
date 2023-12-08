module "efs_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.1.0"

  name   = "${local.name_prefix}-efs-sg"
  vpc_id = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      rule                     = "nfs-tcp"
      source_security_group_id = module.server_sg.security_group_id
    }
  ]

  tags = {
    Service = "EFS"
  }
}

module "efs" {
  source  = "terraform-aws-modules/efs/aws"
  version = "~> 1.3.1"

  creation_token        = "${local.name_prefix}-efs"
  create_security_group = false
  kms_key_arn           = module.efs_kms.key_arn

  access_points = { for _, directory in local.martini_volumes : directory => {
    posix_user = {
      gid = 2006
      uid = 2006
    }

    root_directory = {
      path = "/${directory}"

      creation_info = {
        owner_gid   = 2006
        owner_uid   = 2006
        permissions = "0755"
      }
    }
  } }

  mount_targets = { for az, subnet in zipmap(module.vpc.azs, module.vpc.private_subnets) : az => {
    security_groups = [module.efs_sg.security_group_id]
    subnet_id       = subnet
  } }

  policy_statements = [
    {
      actions = [
        "elasticfilesystem:ClientMount",
        "elasticfilesystem:ClientRootAccess",
        "elasticfilesystem:ClientWrite",
      ]
      principals = [
        {
          type        = "AWS"
          identifiers = [aws_iam_role.task_role.arn]
        }
      ]
    }
  ]

  tags = {
    Service = "EFS"
  }
}