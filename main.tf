terraform {
  required_providers {
    aws = {
    source = "hashicorp/aws"
    version = "~>3.20"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = "saml"
}

module "sg_module" {
  source         = "./sg_module"
  vpcid          = lookup(var.vpc_id, var.aws_regions)
  ssl_cidr_block = var.https_cidr_block
  sg_tag         = var.sg_tag
}

data "aws_subnet" "private_b" {
  vpc_id = lookup(var.vpc_id, var.aws_regions)
  filter {
    name   = "tag:Name"
    values = ["Subnet-B"]
  }
}

data "aws_subnet" "private_c" {
  vpc_id = lookup(var.vpc_id, var.aws_regions)
  filter {
    name   = "tag:Name"
    values = ["Subnet-C"]
  }
}

module "asg_module" {
  sgid            = module.sg_module.sg_id_output
  subnet_2b       = data.aws_subnet.private_b.id
  subnet_2c       = data.aws_subnet.private_c.id
  asg_service_arn = data.aws_iam_role.example_asg_arn.arn
  min_asg         = var.min_cp_asg
  max_asg         = var.max_cp_asg
  desired_asg     = var.desired_cp_asg
  scale_down      = var.K_scale_down
  scale_up        = var.K_scale_up
  asg_metric_type = var.asg_metric_type
  asg_name        = var.asg_name
  iam_role_ec2    = lookup(var.k_iam_role, var.aws_regions)
  source          = "./asg_module"
  amiid           = lookup(var.aws_amis, var.aws_regions)
  instance_typ    = var.instance_type
  ec2_name        = var.ec2_name
}
  
/*
  module "ec2_module" {
  sgid     = module.sg_module.sg_id_output
  subnet_2b = data.aws_subnet.private.id
  source   = "./ec2_module"
  amiid    = lookup(var.aws_amis, var.aws_regions)
  ec2_name = var.ec2_name
}

output "ec2_module_privip" {
  value = module.ec2_module.ec2_private_Address
}
  
*/
