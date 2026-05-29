provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "day2_ec2" {
  ami = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = "DevOps-Day2-Terraform-EC2"
  }
}