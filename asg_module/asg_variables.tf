variable "amiid" {}
variable "instance_typ" {}
variable "sgid" {}
variable "key_name" {
  default = "example-terra-key"
}
variable "pub_key" {
  default = "./.ssh/example-terra-key.pub"
}
variable "iam_role_ec2" {}
variable "init_script" {
  default = "./scripts/install.sh"
}

#### VPC Subnet ######
variable "subnet_2b" {}
variable "subnet_2c" {}

##### Ec2 tags #######
variable "ec2_name" {}
variable "customers" {
  default = "Fleet International"
}


###### AWS ASG - capacity ##############
variable "asg_name" {}
variable "min_asg" {}
variable "max_asg" {}
variable "desired_asg" {}
variable "asg_service_arn" {}
variable "scale_down" {}
variable "scale_up" {}
variable "asg_metric_type" {}

####### SNS ###################
variable "example_sns_asg" {
  default = "example-QA-ASG"  
}
