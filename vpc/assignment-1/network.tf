##################################################################################
# DATA
##################################################################################

data "aws_availability_zones" "available" {}

##################################################################################
# RESOURCES
##################################################################################

# NETWORKING #

# vpc
resource "aws_vpc" "my_vpc" {
  cidr_block       = var.vpc_cidr_block
  enable_dns_hostnames    = var.enable_dns_hostnames

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-vpc"
  })
}


resource "aws_subnet" "public_subnet" {
  depends_on = [
      aws_vpc.my_vpc,
    ]

  count = 2
  cidr_block = var.public_subnets[count.index]
  availability_zone = var.availability_zone[count.index]
  vpc_id = aws_vpc.my_vpc.id
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags = {
    # Name = "${cidr_block}-${availability_zone.name}-${count.index+1}"
    Name = "public-subnet-${count.index+1}"
  }
}

resource "aws_subnet" "private_subnet" {
  depends_on = [
      aws_vpc.my_vpc,
    ]

  count = 2
  cidr_block = var.private_subnets[count.index]
  availability_zone = var.availability_zone[count.index]
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    # Name = "${cidr_block}-${availability_zone.name}-${count.index+1}"
    Name = "private-subnet-${count.index+1}"
  }
}

resource "aws_internet_gateway" "igw" {
  depends_on = [
      aws_vpc.my_vpc,
    ]

  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "${local.name_prefix}-igw"
  }
}

resource "aws_route_table" "IG_route_table" {
  depends_on = [
      aws_vpc.my_vpc,
    ]

  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${local.name_prefix}-IG-rt"
  }
}

resource "aws_route_table_association" "associate_routetable_to_public_subnet" {
  depends_on = [
    aws_subnet.public_subnet,
    aws_route_table.IG_route_table,
  ]

  count = 2
  route_table_id = aws_route_table.IG_route_table.id
  subnet_id = aws_subnet.public_subnet.*.id[count.index]
}

# elastic ip
resource "aws_eip" "elastic_ip" {
  count = 2
  vpc   = true
}

# NAT gateway
resource "aws_nat_gateway" "nat_gateway" {
  depends_on = [
    aws_subnet.public_subnet,
    aws_eip.elastic_ip,
  ]
  count         = 2
  allocation_id = aws_eip.elastic_ip.*.id[count.index]
  subnet_id     = aws_subnet.public_subnet.*.id[count.index]

  tags = {
    Name = "${local.name_prefix}-nat-gateway-${count.index+1}"
  }
}

# route table with target as NAT gateway
resource "aws_route_table" "NAT_route_table" {
  depends_on = [
    aws_vpc.my_vpc,
    aws_nat_gateway.nat_gateway,
    ]

  vpc_id = aws_vpc.my_vpc.id
  count = 2
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.*.id[count.index]
  }

  tags = {
    Name = "${local.name_prefix}-NAT-rt-${count.index+1}"
  }
}

# associate route table to private subnet
resource "aws_route_table_association" "associate_routetable_to_private_subnet" {
  depends_on = [
    aws_subnet.private_subnet,
    aws_route_table.NAT_route_table,
  ]

  count          = 2
  subnet_id      = aws_subnet.private_subnet.*.id[count.index]
  route_table_id = aws_route_table.NAT_route_table.*.id[count.index]
}

