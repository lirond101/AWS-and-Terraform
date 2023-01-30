##################################################################################
# DATA
##################################################################################

data "aws_ami" "ubuntu-18" {
  most_recent = true
  owners      = [var.ubuntu_account_number]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

##################################################################################
# RESOURCES
##################################################################################

# INSTANCES #
resource "aws_instance" "nginx" {
  count                  = var.instance_count
  ami                    = data.aws_ami.ubuntu-18.id
  instance_type          = var.instance_type
  subnet_id              = module.vpc.public_subnets[(count.index % var.vpc_subnet_count)]
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]

  user_data              = local.my-instance-userdata

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-nginx-${count.index}"
  })
}


resource "aws_instance" "db" {
  count                  = var.instance_count
  ami                    = data.aws_ami.ubuntu-18.id
  instance_type          = var.instance_type
  subnet_id              = module.vpc.private_subnets[(count.index % var.vpc_subnet_count)]
  vpc_security_group_ids = [aws_security_group.db-sg.id]

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-db-${count.index}"
  })
}