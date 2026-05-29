provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "day2_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "DevOps-Day2-Terraform-VPC"
  }
}

resource "aws_subnet" "day2_subnet" {
  vpc_id = aws_vpc.day2_vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.aws_availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "DevOps-Day2-Terraform-SUBNET"
  }
}
resource "aws_internet_gateway" "day2_igw" {
  vpc_id = aws_vpc.day2_vpc.id

  tags = {
    Name = "DevOps-Day2-Terraform-IGW"
  }
}
resource "aws_route_table" "day2_rt" {
  vpc_id = aws_vpc.day2_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.day2_igw.id
  }

  tags = {
    Name = "DevOps-Day2-Terraform-RT"
  }
}

resource "aws_route_table_association" "day2_rta" {
  subnet_id = aws_subnet.day2_subnet.id
  route_table_id = aws_route_table.day2_rt.id
}
resource "aws_security_group" "day2_sg"
{
  name = "DevOps-Day2-Terraform-SG"
  description = "Security group for EC2 instance"
  vpc_id = aws_vpc.day2_vpc.id

  ingress {
    description = "SSH access"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP access"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "DevOps-Day2-Terraform-SG"
  }
}

resource "aws_instance" "day2_ec2" {
  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.day2_subnet.id
  vpc_security_group_ids = [aws_security_group.day2_sg.id]
  associate_public_ip_address = true
  key_name = var.key_name

  tags = {
    Name = "DevOps-Day2-Terraform-EC2"
  }
}