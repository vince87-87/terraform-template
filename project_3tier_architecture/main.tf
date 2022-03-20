module "network" {
  source                       = "../modules/AWS/vpc/"
  vpc_name                     = "${var.applications}-vpc"
  application_name             = var.applications
  internetgw_name              = "${var.applications}-igw"
  pubic_route_table_name       = "${var.applications}-rtb-public"
  app_route_table_name         = "${var.applications}-rtb-app"
  db_route_table_name          = "${var.applications}-rtb-db"
  vpc_cidr_block               = var.vpc_cidr
  public_subnet                = [for i in range(1, 4, 1) : cidrsubnet(var.vpc_cidr, 8, i)]
  app_subnet                   = [for i in range(4, 7, 1) : cidrsubnet(var.vpc_cidr, 8, i)]
  db_subnet                    = [for i in range(8, 11, 1) : cidrsubnet(var.vpc_cidr, 8, i)]
  number_of_public_route_table = var.number_of_public_route_table
  number_of_app_route_table    = var.number_of_app_route_table
  number_of_db_route_table     = var.number_of_db_route_table
  default_route_destination    = var.default_route_destination
  common_tags                  = var.common_tags
  vpc_tags = {
    Terraform = "True"
  }
  subnet_tags = {
    Terraform = "True"
  }
}

locals {
  security_groups = {
    app = {
      name        = join("-", [var.applications, "SG", var.app_tier_name])
      description = "Security Group For EC2 APP"
    }
    web = {
      name        = join("-", [var.applications, "SG", var.web_tier_name])
      description = "Security Group For EC2 Web"
    }
    db = {
      name        = join("-", [var.applications, "SG", var.db_tier_name])
      description = "Security Group For EC2 DB"
    }
  }
}
locals {
  ingress_rule = {
    http = {
      description       = "allow http"
      fromport          = 80
      toport            = 80
      protocol          = "tcp"
      cidr_blocks       = ["0.0.0.0/0"]
      security_group_id = module.SG.sg_id["web"].id
    }
    ssh = {
      description       = "allow ssh"
      fromport          = 22
      toport            = 22
      protocol          = "tcp"
      cidr_blocks       = ["172.16.0.0/16"]
      security_group_id = module.SG.sg_id["web"].id
    }
  }
}
locals {
  ingress_rule_sourceid = {
    web = {
      description       = "allow http from app sg"
      fromport          = 80
      toport            = 80
      protocol          = "tcp"
      sourcesgid        = module.SG.sg_id["app"].id
      security_group_id = module.SG.sg_id["web"].id
    }
  }
}


locals {
  ec2 = {
    svr1 = {
      tag_ec2_name = join("-", [var.applications, "app", 0])
    }
  }
}
locals {
  root_block_device = {
    root_os = {
      delete_on_termination = true
      volume_size = 100
      volume_type = "gp2"
      tags = merge(
        {
          Name = join("-", [var.applications, "os_ebs",1])
        },
        var.common_tags,
      )
    }
  }
}


module "SG" {
  source                = "../modules/AWS/security_group/"
  application_name      = var.applications
  vpcid                 = module.network.vpc_id
  security_group        = local.security_groups
  common_tags           = var.common_tags
  ingress_rule          = local.ingress_rule
  create_SG_Cidr_Block  = true
  create_SG_SourceSG_ID = true
  ingress_rule_sourceid = local.ingress_rule_sourceid
}

# module "keypair" {
#   source = "../modules/AWS/keypair/"
#   key_name = join("-", [var.applications, "keypair", "app"])
#   public_key = var.public_key
#   tag_kp_name = join("-", [var.applications, "keypair", "app"])
#   common_tags = var.common_tags
# }

# module "ec2" {
#   source        = "../modules/AWS/ec2/"
#   for_each      = local.ec2
#   tag_ec2_name  = each.value.tag_ec2_name #join("-", [var.applications, "app", 0])
#   common_tags   = var.common_tags
#   ami           = var.ami
#   instance_type = var.instance_type
#   termination_protection = var.termination_protection
#   AZ            = element(var.AZ, 0)
#   sg_id         = [module.SG.sg_id["app"].id]
#   keypair       = module.keypair.key_name[0]
#   subnet_id     = element(module.network.app_subnet_id, 0)
#   root_block_device = local.root_block_device
# }

module "ecs" {
  source = "../modules/AWS/ecs/"
  applications = var.applications
  tag_ecs_cluster_name = "${var.applications}-ecs-1"
  common_tags = var.common_tags
  capacity_providers = ["FARGATE"]
}

module "ecr" {
  source = "../modules/AWS/ecr/"
  applications = var.applications
  tag_name_ecr = "${var.applications}-ecr-1"
  common_tags = var.common_tags
}