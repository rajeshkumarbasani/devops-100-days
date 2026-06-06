provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "day4_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Day4-VPC"
  }
}

resource "aws_subnet" "day4_public_subnet" {
  vpc_id                  = aws_vpc.day4_vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "Day4-Public-Subnet"
  }
}

resource "aws_internet_gateway" "day4_igw" {
  vpc_id = aws_vpc.day4_vpc.id

  tags = {
    Name = "Day4-Internet-Gateway"
  }
}

resource "aws_route_table" "day4_public_rt" {
  vpc_id = aws_vpc.day4_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.day4_igw.id
  }

  tags = {
    Name = "Day4-Public-Route-Table"
  }
}

resource "aws_route_table_association" "day4_public_assoc" {
  subnet_id      = aws_subnet.day4_public_subnet.id
  route_table_id = aws_route_table.day4_public_rt.id
}

module "web_server" {
  source = "../../modules/ec2"

  ami_id        = var.ami_id
  instance_type = var.instance_type
  instance_name = var.instance_name
  key_name      = var.key_name
  my_ip         = var.my_ip

  vpc_id    = aws_vpc.day4_vpc.id
  subnet_id = aws_subnet.day4_public_subnet.id
}
