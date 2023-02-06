##################################################################################
# DATA
##################################################################################

data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

##################################################################################
# RESOURCES
##################################################################################

# INSTANCES #
resource "aws_instance" "nginx" {
  depends_on = [
    aws_security_group.nginx-sg,
  ]

  count                  = var.instance_count
  ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type          = var.instance_type
  subnet_id              = keys(module.my_vpc.vpc_private_subnets)[count.index]
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  associate_public_ip_address = "true"
  key_name               = var.key_name
  iam_instance_profile   = module.web_app_s3.instance_profile.name
  
  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> nginx-${count.index+1}.txt"
  }
  user_data = templatefile("${path.module}/startup_script.tpl", {
    public_ip = "${file("nginx-${count.index+1}.txt")}"
  })
  
  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-nginx-${count.index+1}"
  })  
}



resource "aws_instance" "db" {
  depends_on = [
    aws_security_group.db-sg,
    module.my_vpc
  ]

  count                  = var.instance_count
  ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type          = var.instance_type
  subnet_id              = keys(module.my_vpc.vpc_private_subnets)[count.index]
  vpc_security_group_ids = [aws_security_group.db-sg.id]
  key_name               = var.key_name

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-db-${count.index+1}"
  })
}