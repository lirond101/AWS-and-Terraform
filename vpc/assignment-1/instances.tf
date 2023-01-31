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
  subnet_id              = aws_subnet.public_subnet.*.id[count.index]
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  key_name = var.key_name
  user_data              = local.my-instance-userdata

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-nginx-${count.index+1}"
  })
}


resource "aws_instance" "db" {
  count                  = var.instance_count
  ami                    = data.aws_ami.ubuntu-18.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_subnet.*.id[count.index]
  vpc_security_group_ids = [aws_security_group.db-sg.id]
  key_name = var.key_name

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-db-${count.index+1}"
  })
}