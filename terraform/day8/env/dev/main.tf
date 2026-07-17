data "aws_ssm_parameter" "amazon_linux_2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = var.owner
    Repository  = "devops-100-days"
  }
}

module "vpc" {
  source = "../../modules/vpc"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = var.availability_zone

  tags = local.common_tags
}

module "ec2" {
  source = "../../modules/ec2"

  project_name = var.project_name
  environment  = var.environment

  vpc_id   = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnet_id

  ami_id        = data.aws_ssm_parameter.amazon_linux_2023_ami.value
  instance_type = var.instance_type
  key_name      = var.key_name

  ssh_allowed_cidrs  = var.ssh_allowed_cidrs
  http_allowed_cidrs = var.http_allowed_cidrs

  docker_image     = var.docker_image
  application_port = 3000
  host_port        = 80
  root_volume_size = var.root_volume_size

  tags = local.common_tags
}