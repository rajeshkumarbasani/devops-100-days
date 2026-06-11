# Day 6 Terraform AWS Provisioning

This directory contains the Terraform configuration for Day 6 of the DevOps 100 Days challenge.
The setup provisions a VPC and an EC2 instance using reusable Terraform modules.

## Structure

- [`modules/vpc`](modules/vpc) - creates the VPC, public subnet, internet gateway, and route table.
- [`modules/ec2`](modules/ec2) - creates an EC2 instance inside the VPC public subnet.
- [`env/dev`](env/dev) - environment configuration for the `dev` deployment.

## Provisioning AWS Resources

### 1. Change into the dev environment

```bash
cd terraform/day6/env/dev
```

This command changes the current directory to the Day 6 development environment.

### 2. Format configuration files

```bash
terraform fmt -recursive
```

Formats all Terraform files in the current module and subdirectories.

### 3. Initialize Terraform

```bash
terraform init
```

Downloads providers, initializes the working directory, and prepares the environment.

### 4. Validate the configuration

```bash
terraform validate
```

Checks the syntax and internal consistency of Terraform configuration files.

### 5. Review the plan

```bash
terraform plan
```

Shows the execution plan so you can inspect the proposed changes before applying them.

### 6. Apply the deployment

```bash
terraform apply -auto-approve
```

Applies the Terraform plan and provisions resources defined in `env/dev/main.tf`.

## Module flow

The `env/dev/main.tf` file uses:

- [`modules/vpc`](modules/vpc)
- [`modules/ec2`](modules/ec2)

The VPC module builds network resources and exposes `vpc_id` and `public_subnet_id`.
The EC2 module consumes those outputs to launch the instance into the created subnet.

## Environment Configuration

The `env/dev` configuration passes variables to both modules:

- `project_name` and `environment` to tag resources consistently
- `vpc_cidr` and `public_subnet_cidr` for network layout
- `availability_zone` for subnet placement
- `ami_id`, `instance_type`, `key_name`, `my_ip`, `volume_type`, and `volume_size` for the EC2 instance

## Clean up and save credits

```bash
terraform destroy -auto-approve
```

Destroys all resources created by the deployment and prevents ongoing cloud costs.

## Notes

- The [`vpc` module](modules/vpc/README.md) creates the VPC, public subnet, internet gateway, and route table.
- The [`ec2` module](modules/ec2/README.md) launches the instance into the public subnet and uses the VPC created by the `vpc` module.
- This repository uses a modular approach so network and compute resources can be reused in other environments.
