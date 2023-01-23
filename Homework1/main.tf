##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "us-east-1"
}

##################################################################################
# DATA
##################################################################################

data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

##################################################################################
# RESOURCES
##################################################################################

# NETWORKING #
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

}

resource "aws_subnet" "subnet1" {
  cidr_block              = "10.0.0.0/24"
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
}

# ROUTING #
resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta-subnet1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.rtb.id
}

# SECURITY GROUPS #
# Nginx security group 
resource "aws_security_group" "nginx-sg" {
  name   = "nginx_sg"
  vpc_id = aws_vpc.vpc.id

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# INSTANCES #
resource "aws_instance" "nginx1" {
  ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  root_block_device {
      tags = {
          "FileSystem" = "/root"
        }
  }
  ebs_block_device {
      device_name = "/dev/sda1"
      encrypted = true
      volume_type = "gp2"
      volume_size = "10"
      tags = {
          "FileSystem" = "/liron/data"
      }
  }

  user_data = <<EOF
#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
sudo rm /usr/share/nginx/html/index.html
echo "<html><body><h1>Welcome to Grandpa's Whiskey</h1></body></html>" | sudo tee /usr/share/nginx/html/index.html
EOF

tags = {
    owner = "Liron Dadon"
    server_name = "Server1"
    purpose = "whiskey" 
  }
}

resource "aws_instance" "nginx2" {
  ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  root_block_device {
      tags = {
          "FileSystem" = "/root"
        }
  }
  ebs_block_device {
      device_name = "/dev/sda2"
      encrypted = true
      volume_type = "gp2"
      volume_size = "10"
      tags = {
          "FileSystem" = "/liron/data"
      }
  }

  user_data = <<EOF
#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
sudo rm /usr/share/nginx/html/index.html
echo "<html><body><h1>Welcome to Grandpa's Whiskey</h1></body></html>" | sudo tee /usr/share/nginx/html/index.html
EOF

  tags = {
    owner = "Liron Dadon"
    server_name = "Server2"
    purpose = "whiskey" 
  }
}

