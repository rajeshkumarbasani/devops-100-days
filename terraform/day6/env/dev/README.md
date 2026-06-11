cd ~/devops-100-days/terraform/day6/env/dev

# Provision Day 6 Terraform Dev Environment

This directory builds the Day 6 AWS development environment using two reusable modules:

- `modules/vpc` for networking resources
- `modules/ec2` for compute resources

## Provisioning commands

terraform fmt -recursive
terraform init
terraform validate
terraform plan
terraform apply -auto-approve

## How this environment is built

The `env/dev/main.tf` file defines the environment and stitches the modules together.

1. `module "vpc"` creates the network foundation:
   - VPC
   - public subnet
   - internet gateway
   - public route table
   - route table association

2. `module "ec2"` creates the compute instance and security group:
   - EC2 instance launched into the public subnet
   - security group allowing SSH from `my_ip`
   - security group allowing HTTP access on port 80
   - Docker installation and NGINX container deployment via user data
   - encrypted root EBS volume

The `ec2` module consumes outputs from the `vpc` module:

- `module.vpc.vpc_id` is passed to `ec2.vpc_id`
- `module.vpc.public_subnet_id` is passed to `ec2.subnet_id`

This means the EC2 instance is launched into the VPC and subnet created by the `vpc` module.

## Notes

- `terraform fmt -recursive` formats the configuration files.
- `terraform init` initializes the working directory and downloads modules/providers.
- `terraform validate` checks syntax and configuration correctness.
- `terraform plan` shows the execution plan for the `dev` environment.
- `terraform apply -auto-approve` provisions the infrastructure without interactive approval.
- `terraform destroy -auto-approve` removes the created infrastructure to avoid ongoing costs.

## Clean Up

Use `terraform destroy -auto-approve` when you no longer need this environment. This helps save cloud costs by tearing down resources created for Day 6 development.