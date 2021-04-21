resource "aws_security_group" "Terra_sg_N" {
  name        = "Terra_sg_N"
  description = "Ec2 connection webserver"
  vpc_id      = var.vpcid
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.ssl_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = var.sg_tag
  }
}

output "sg_id_output" {
  value = aws_security_group.Terra_sg_N.id
}