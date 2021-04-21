variable "aws_regions" {
  default = "us-east-2"
}
variable "aws_amis" {
  type = map
  default = {
    "us-east-2" = "ami-xxxxx"
    "us-west-2" = "ami-0xxxx"
  }
}
variable "vpc_id" {
  type = map
  default = {
    "us-east-2" = "vpc-xxxxxx"
    "us-west-2" = "vpc-xxxxxx"
  }
}

variable "k_iam_role" {
  type = map 
  default = {
    "us-east-2" = "ec2FullAccess"
    "us-west-2" = "ec2fullaccess-DR"
  }
}

variable "https_cidr_block" {
  default = "0.0.0.0/0"
}

variable "sg_tag" {}

variable "asg_arn" {
  default = "AWSServiceRoleForAutoScaling"
}

variable "instance_type" {}
variable "ec2_name" {}
variable "min_cp_asg" {}
variable "max_cp_asg" {}
variable "desired_cp_asg" {}
variable "asg_name" {}
variable "K_scale_down" {}
variable "K_scale_up" {}
variable "asg_metric_type" {
  default = "ASGAverageCPUUtilization"
}
