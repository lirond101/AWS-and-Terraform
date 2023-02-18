# DATA
data "aws_ami" "ubuntu-18" {
  most_recent = true
  owners      = [var.ubuntu_account_number]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

# INSTANCES #
module "my_ec2" {
    depends_on = [
    module.my_vpc,
    module.web_app_s3
  ]
  source = "https://github.com/lirond101/AWS-and-Terraform/tree/main/tfc/modules/terraform-aws-ec2"

  instance_count_nginx         = var.instance_count
  instance_count_db            = var.instance_count
  ami                          = data.aws_ami.ubuntu-18.id
  instance_type                = var.instance_type
  nginx_iam_instance_profile   = module.web_app_s3.instance_profile.name
  subnet_id_nginx              = keys(module.my_vpc.vpc_public_subnets)[count.index]
  subnet_id_db                 = keys(module.my_vpc.vpc_private_subnets)[count.index]

  user_data = templatefile("${path.module}/startup_script.tpl", {
    vpc_cidr_block = module.my_vpc.vpc_cidr_block
    })

  common_tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-ec2",
    Version = "v1.0.0"
  })
}