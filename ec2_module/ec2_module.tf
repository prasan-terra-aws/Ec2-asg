##### AWS Availability Zones ######
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_key_pair" "devkey" {
  key_name   = var.key_name
  public_key = file(var.pub_key)
}

resource "aws_instance" "web_ec2_instance" {
  ami                    = var.amiid
  instance_type          = var.instance_typ
  key_name               = var.key_name
  subnet_id              = var.subnet_2b
  vpc_security_group_ids = [var.sgid]
  iam_instance_profile   = var.iam_role_ec2
  user_data              = file(var.init_script)
  tags = {
    Name          = var.ec2_name
    Customers     = var.customers
  }
}

output "ec2_private_Address" {
  value = aws_instance.web_ec2_instance.private_ip
}