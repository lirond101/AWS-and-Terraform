# SECURITY GROUPS #
# ALB Security Group
resource "aws_security_group" "alb_sg" {
  depends_on = [
    aws_vpc.my_vpc,
  ]
  name   = "${local.name_prefix}-nginx_alb_sg"
  vpc_id = aws_vpc.my_vpc.id

  #Allow HTTP from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

# Nginx security group 
resource "aws_security_group" "nginx-sg" {
  depends_on = [
    aws_vpc.my_vpc,
  ]
  name   = "${local.name_prefix}-nginx_sg"
  vpc_id = aws_vpc.my_vpc.id

  # HTTP access from VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
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

  tags = local.common_tags
}

# DB security group 
resource "aws_security_group" "db-sg" {
  depends_on = [
    aws_vpc.my_vpc,
  ]
  name   = "${local.name_prefix}-db_sg"
  vpc_id = aws_vpc.my_vpc.id

  # HTTP access from public subnets
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.public_subnets
  }

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
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

  tags = local.common_tags
}

