# SECURITY GROUPS #
# ALB Security Group
resource "aws_security_group" "alb_sg" {
  depends_on = [
    module.my_vpc,
  ]
  name   = "${local.name_prefix}-nginx_alb_sg"
  vpc_id = module.my_vpc.vpc_id
  tags = local.common_tags
}

resource "aws_security_group_rule" "allow_http" {
 type              = "ingress"
 description       = "HTTP ingress"
 from_port         = 80
 to_port           = 80
 protocol          = "tcp"
 cidr_blocks       = ["0.0.0.0/0"]
 security_group_id = aws_security_group.alb_sg.id
}

resource "aws_security_group_rule" "alb_allow_all_outbound" {
 type              = "egress"
 description       = "outbound internet access"
 from_port         = 0
 to_port           = 0
 protocol          = "-1"
 cidr_blocks       = ["0.0.0.0/0"]
 security_group_id = aws_security_group.alb_sg.id
}

# Nginx security group 
resource "aws_security_group" "nginx_sg" {
  depends_on = [
    module.my_vpc,
  ]
  name   = "${local.name_prefix}-nginx_sg"
  vpc_id = module.my_vpc.vpc_id
  tags = local.common_tags
}

resource "aws_security_group_rule" "nginx_allow_http_from_vpc" {
 type              = "ingress"
 description       = "HTTP access from VPC"
 from_port         = 80
 to_port           = 80
 protocol          = "tcp"
 cidr_blocks       = [module.my_vpc.vpc_cidr_block]
 security_group_id = aws_security_group.nginx_sg.id
}

resource "aws_security_group_rule" "nginx_allow_ssh" {
 type              = "ingress"
 description       = "SSH access from Anywhere"
 from_port         = 22
 to_port           = 22
 protocol          = "tcp"
 cidr_blocks       = ["0.0.0.0/0"]
 security_group_id = aws_security_group.nginx_sg.id
}

resource "aws_security_group_rule" "nginx_allow_all_outbound" {
 type              = "egress"
 description       = "outbound internet access"
 from_port         = 0
 to_port           = 0
 protocol          = "-1"
 cidr_blocks       = ["0.0.0.0/0"]
 security_group_id = aws_security_group.nginx_sg.id
}

# DB security group 
resource "aws_security_group" "db_sg" {
  depends_on = [
    module.my_vpc,
  ]
  name   = "${local.name_prefix}-db_sg"
  vpc_id = module.my_vpc.vpc_id
  tags = local.common_tags
}

resource "aws_security_group_rule" "db_allow_http" {
 type              = "ingress"
 description       = "HTTP access through public subnets"
 from_port         = 80
 to_port           = 80
 protocol          = "tcp"
 cidr_blocks       = values(module.my_vpc.vpc_public_subnets)[*]
 security_group_id = aws_security_group.db_sg.id
}

resource "aws_security_group_rule" "db_allow_ssh" {
 type              = "ingress"
 description       = "SSH access from Anywhere"
 from_port         = 22
 to_port           = 22
 protocol          = "tcp"
 cidr_blocks       = ["0.0.0.0/0"]
 security_group_id = aws_security_group.db_sg.id
}

resource "aws_security_group_rule" "db_allow_all_outbound" {
 type              = "egress"
 description       = "outbound internet access"
 from_port         = 0
 to_port           = 0
 protocol          = "-1"
 cidr_blocks       = ["0.0.0.0/0"]
 security_group_id = aws_security_group.db_sg.id
}