locals { common_tags = { Project=var.project_name, Environment=var.environment, ManagedBy="Terraform", Owner=var.owner, Repository="devops-100-days" } }
module "network" {
  source="../../modules/network"
  project_name=var.project_name
  environment=var.environment
  vpc_cidr=var.vpc_cidr
  availability_zones=var.availability_zones
  public_subnet_cidrs=var.public_subnet_cidrs
  private_subnet_cidrs=var.private_subnet_cidrs
  single_nat_gateway=var.single_nat_gateway
  tags=local.common_tags
}
module "ecs" {
  source="../../modules/ecs"
  project_name=var.project_name
  environment=var.environment
  vpc_id=module.network.vpc_id
  public_subnet_ids=module.network.public_subnet_ids
  private_subnet_ids=module.network.private_subnet_ids
  container_image=var.container_image
  desired_count=var.desired_count
  min_capacity=var.min_capacity
  max_capacity=var.max_capacity
  tags=local.common_tags
}
