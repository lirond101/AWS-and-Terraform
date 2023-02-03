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
  subnet_id              = aws_subnet.private_subnet.*.id[count.index]
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  key_name               = var.key_name
  user_data              = local.my-instance-userdata

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-nginx-${count.index + 1}"
  })
}


resource "aws_instance" "db" {
  depends_on = [
    aws_security_group.db-sg,
    aws_nat_gateway.nat_gateway,
    aws_route_table_association.associate_routetable_to_private_subnet
  ]

  count                  = var.instance_count
  ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_subnet.*.id[count.index]
  vpc_security_group_ids = [aws_security_group.db-sg.id]
  key_name               = var.key_name

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-db-${count.index + 1}"
  })
}