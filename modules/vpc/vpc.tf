data "aws_availability_zones" "az" {
  state = "available"
}

data "aws_region" "current" {}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = merge(var.default_tags, {
    Name        = "vpc-${var.env}-${var.project_name}"
    description = "VPC for ${var.env}-${var.project_name}"
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.default_tags, {
    Name        = "igw-${var.env}-${var.project_name}"
    description = "igw for ${var.env}-${var.project_name}"
  })
}

resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.az.names[count.index]

  tags = merge(var.default_tags, {
    Name        = "public-subnet-${data.aws_availability_zones.az.names[count.index]}-${var.env}-${var.project_name}"
    description = "public subnet for ${var.env}-${var.project_name}"
  })
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.az.names[count.index]


  tags = merge(var.default_tags, {
    Name        = "private-subnet-${data.aws_availability_zones.az.names[count.index]}-${var.env}-${var.project_name}"
    description = "private subnet for ${var.env}-${var.project_name}"
  })
}

resource "aws_eip" "nat" {
  count  = var.create_nat_gateway ? length(var.public_subnet_cidr) : 0
  domain = "vpc"
  tags = merge(var.default_tags, {
    Name        = "eip-nat-gw-${var.env}-${var.project_name}"
    description = "eip-nat-gw for ${var.env}-${var.project_name}"
  })
}
# This might malfunction do check it
resource "aws_nat_gateway" "nat" {
  # count         = var.create_nat_gateway ? 1 : 0
  count         = var.create_nat_gateway ? length(var.public_subnet_cidr) : 0
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(var.default_tags, {
    Name        = "nat-gw-${var.env}-${var.project_name}"
    description = "nat-gw for ${var.env}-${var.project_name}"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.default_tags, {
    Name        = "public-rt-${var.env}-${var.project_name}"
    description = "public-rt for ${var.env}-${var.project_name}"
  })
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  count  = length(var.private_subnet_cidr)
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.create_nat_gateway ? aws_nat_gateway.nat[count.index].id : aws_internet_gateway.igw.id
  }

  tags = merge(var.default_tags, {
    Name        = "private-rt-${var.env}-${var.project_name}"
    description = "private-rt for ${var.env}-${var.project_name}"
  })
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidr)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
