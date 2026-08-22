locals {
  name = "${var.project_name}-${var.environment}"
  tags = { Project=var.project_name, Environment=var.environment, ManagedBy="Terraform", Day="10" }
}
module "network" {
  source = "../../modules/network"
  name = local.name
  vpc_cidr = var.vpc_cidr
  azs = var.availability_zones
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  single_nat_gateway = true
  tags = local.tags
}

module "platform" {
  source = "../../modules/platform"
  name = local.name
  vpc_id = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  tags = local.tags
}
output "cluster_name" { value = module.platform.cluster_name }
output "cluster_endpoint" { value = module.platform.cluster_endpoint }
