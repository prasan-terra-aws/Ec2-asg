variable "amiid" {}

variable "instance_typ" {
  default = "t4g.micro"
}

variable "sgid" {}

variable "subnet_2b" {}

variable "key_name" {
  default = "example-terra-key"
}

variable "pub_key" {
  default = "./.ssh/example-terra-key.pub"
}

variable "iam_role_ec2" {
  default = "exampleFullAccess"
}

variable "ec2_name" {}

variable "customers" {
  default = "Fleet_xee"
}

variable "init_script" {
  default = "./scripts/install.sh"

}