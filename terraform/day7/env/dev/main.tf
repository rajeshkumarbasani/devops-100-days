locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = "Rajeshkumar"
  }
}

module "vpc" {
  source = "../../modules/vpc"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = var.availability_zone
  tags               = local.common_tags
}

module "ec2" {
  source = "../../modules/ec2"

  project_name = var.project_name
  environment  = var.environment

  ami_id        = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_id       = module.vpc.vpc_id
  subnet_id    = module.vpc.public_subnet_id
  my_ip        = var.my_ip
  docker_image = var.docker_image

  volume_size = var.volume_size
  tags        = local.common_tags
}