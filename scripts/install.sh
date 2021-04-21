#!/bin/bash

sudo yum update -y 

### Installing  
sudo amazon-linux-extras install docker nginx1 -y

sudo systemctl enable docker
sudo systemctl start docker 
sudo usermod -a -G docker ec2-user

sudo systemctl enable nginx
sudo systemctl start nginx
#sudo mv /etc/nginx /etc/nginx-backup

### Download config file from S3 bucket #####
#aws s3 cp s3://bucket_name/nginx-config.zip /tmp

#### Update the new configuration
#unzip /tmp/nginx-config.zip -d /etc/nginx
