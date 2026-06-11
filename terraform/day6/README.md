# Day 6 Terraform AWS Provisioning

This directory contains the Terraform configuration for Day 6 of the DevOps 100 Days challenge.
The setup provisions a VPC and an EC2 instance using reusable Terraform modules.

## Structure

- `modules/vpc` - creates the VPC, public subnet, internet gateway, and route table.
- `modules/ec2` - creates an EC2 instance inside the VPC public subnet.
- `env/dev` - environment configuration for the `dev` deployment.

## Provisioning AWS Resources

### 1. Change into the dev environment

```bash
cd terraform/day6/env/dev
```

### 2. Format configuration files

```bash
terraform fmt -recursive
```

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Validate the configuration

```bash
terraform validate
```

### 5. Review the plan

```bash
terraform plan
```

### 6. Apply the deployment

```bash
terraform apply -auto-approve
```

This command provisions the AWS resources defined in the `env/dev` environment, including the VPC and EC2 instance.

## Environment Configuration

The `env/dev` configuration passes variables to both modules:

- `project_name` and `environment` to tag resources consistently
- `vpc_cidr` and `public_subnet_cidr` for network layout
- `availability_zone` for subnet placement
- `ami_id`, `instance_type`, `key_name`, `my_ip`, `volume_type`, and `volume_size` for the EC2 instance

## Clean up and save credits

When you no longer need the environment, destroy it:

```bash
terraform destroy -auto-approve
```

This removes the provisioned AWS resources and helps avoid ongoing AWS costs.

## Notes

- The `vpc` module creates the VPC, public subnet, internet gateway, and route table.
- The `ec2` module launches the instance into the public subnet and uses the VPC created by the `vpc` module.
- This repository uses a modular approach so the network and compute resources can be reused in other environments.
