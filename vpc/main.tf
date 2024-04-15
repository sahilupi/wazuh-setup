resource "aws_vpc" "vpc" {

  cidr_block           = var.vpc.vpc_cidr
  enable_dns_support   = var.vpc.enable_dns_support
  enable_dns_hostnames = var.vpc.enable_dns_hostnames
  instance_tenancy     = var.vpc.instance_tenancy
  tags = {
    Name = "wazuh-vpc"
  }
}

##public subnets##
resource "aws_subnet" "public_subnets" {
  depends_on = [
    aws_vpc.vpc,
  ]

  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.vpc.public_subnets)
  cidr_block              = element(var.vpc.public_subnets, count.index)
  availability_zone       = element(var.vpc.availability_zones, count.index)
  map_public_ip_on_launch = var.vpc.map_public_ip_on_launch
  tags = {
    Name = "pub-sub-${element(var.vpc.availability_zones, count.index)}"
  }
}

##Internet gateway##
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "wazuh-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "wazuh-public-route-table"
  }
}

##association
resource "aws_route_table_association" "public" {
  count          = length(var.vpc.public_subnets)
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

##routes 
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}

##security group
resource "aws_security_group" "vpc-sg" {
  name        = "wazuh-vpc-sg"
  description = "Security group to allow inbound/outbound from the VPC"
  vpc_id      = aws_vpc.vpc.id
  depends_on  = [aws_vpc.vpc]
  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }
  tags = {
    Name = "wazuh-vpc-sg"
  }
}
