cd ~/devops-100-days/terraform/day6/env/dev

# Provision Day 6 Terraform Dev Environment

This directory builds the Day 6 AWS development environment using two reusable modules:

- [`../../modules/vpc`](../../modules/vpc) for networking resources
- [`../../modules/ec2`](../../modules/ec2) for compute resources

See [`../../modules/vpc/README.md`](../../modules/vpc/README.md) and [`../../modules/ec2/README.md`](../../modules/ec2/README.md) for details.

## Provisioning commands

### 1. Format Terraform files

```bash
terraform fmt -recursive
```

Formats the Terraform files in this directory and the referenced modules.

### 2. Initialize Terraform

```bash
terraform init
```

Initializes the working directory, downloads required providers, and prepares the environment.

### 3. Validate the configuration

```bash
terraform validate
```

Validates the configuration syntax and module references.

### 4. Review the execution plan

```bash
terraform plan
```

Shows the proposed changes before applying them.

### 5. Apply the environment

```bash
terraform apply -auto-approve
```

Provision the development environment from `env/dev/main.tf` and linked modules.

## How this environment is built

The `env/dev/main.tf` file orchestrates the environment by using two modules.

### `module "vpc"`

Creates the network foundation:

- VPC
- public subnet
- internet gateway
- public route table
- route table association

### `module "ec2"`

Creates the compute resources and security group:

- EC2 instance launched into the public subnet
- SSH access from `my_ip`
- HTTP access on port 80
- Docker installation and NGINX container deployment via user data
- encrypted root EBS volume

### Module integration

The `ec2` module consumes outputs from the `vpc` module:

- `module.vpc.vpc_id` → `ec2.vpc_id`
- `module.vpc.public_subnet_id` → `ec2.subnet_id`

This ensures the EC2 instance is launched into the VPC and subnet created by the `vpc` module.

## Notes

- `terraform fmt -recursive` formats the Terraform files.
- `terraform init` initializes the working directory and downloads modules/providers.
- `terraform validate` checks syntax and configuration correctness.
- `terraform plan` shows the execution plan for the `dev` environment.
- `terraform apply -auto-approve` provisions the infrastructure without interactive approval.
- `terraform destroy -auto-approve` removes the created infrastructure to avoid ongoing costs.

## Clean Up

Use `terraform destroy -auto-approve` when you no longer need this environment. This helps save cloud costs by tearing down resources created for Day 6 development.
