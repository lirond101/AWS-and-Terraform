##################################################################################
# DATA
##################################################################################

data "aws_availability_zones" "available" {}

##################################################################################
# RESOURCES
##################################################################################

# NETWORKING #

# vpc
module "my_vpc" {
  source = "./modules/vpc"

  availability_zone = var.availability_zone
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets

  common_tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-vpc"
  })
}