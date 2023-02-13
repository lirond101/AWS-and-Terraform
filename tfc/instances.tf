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
  depends_on = [
    aws_security_group.nginx_sg,
  ]

  count                  = var.instance_count
  ami                    = data.aws_ami.ubuntu-18.id
  instance_type          = var.instance_type
  subnet_id              = keys(module.my_vpc.vpc_private_subnets)[count.index]
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  associate_public_ip_address = "true"
  key_name               = var.key_name
  iam_instance_profile   = module.web_app_s3.instance_profile.name
  user_data = templatefile("${path.module}/startup_script.tpl", {
    vpc_cidr_block = module.my_vpc.vpc_cidr_block
  })

  root_block_device {
    encrypted   = false
    volume_type = var.volumes_type
    volume_size = var.nginx_root_disk_size
  }

  ebs_block_device {
    encrypted   = true
    device_name = var.nginx_encrypted_disk_device_name
    volume_type = var.volumes_type
    volume_size = var.nginx_encrypted_disk_size
  }
  
  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-nginx-${count.index+1}"
  })  
}



resource "aws_instance" "db" {
  depends_on = [
    aws_security_group.db_sg,
    module.my_vpc
  ]

  count                  = var.instance_count
  ami                    = data.aws_ami.ubuntu-18.id
  instance_type          = var.instance_type
  subnet_id              = keys(module.my_vpc.vpc_private_subnets)[count.index]
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  associate_public_ip_address = "false"
  key_name               = var.key_name

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-db-${count.index+1}"
  })
}