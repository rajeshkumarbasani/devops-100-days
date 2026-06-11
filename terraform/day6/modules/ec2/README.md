# EC2 Module

This Terraform module provisions an AWS EC2 instance and supporting security group for Day 6.
It is designed to be consumed by an environment configuration such as `terraform/day6/env/dev`.

## What the module creates

- `aws_security_group.this`
  - Allows SSH access from the configured `my_ip` value.
  - Allows HTTP access on port `80` from `http_allowed_cidr`.
  - Allows all outbound traffic.
- `aws_instance.this`
  - Launches an EC2 instance in the provided subnet.
  - Associates a public IP address.
  - Installs Docker and runs an NGINX container serving a simple HTML page.
  - Configures the root EBS volume with the specified `volume_size` and `volume_type`.
  - Enables detailed instance monitoring and IMDSv2 metadata options.

## Module inputs

- `project_name` - used to name resources and tags
- `environment` - used to name resources and tags
- `ami_id` - AMI ID for the EC2 instance
- `instance_type` - EC2 instance type
- `key_name` - key pair name for SSH access
- `vpc_id` - VPC where the security group is created
- `subnet_id` - subnet where the EC2 instance is launched
- `my_ip` - CIDR block used for SSH ingress
- `volume_size` - root volume size in GB (10-20)
- `volume_type` - EBS root volume type (`gp2`, `gp3`, `io1`, `io2`, `st1`, `sc1`, `standard`)
- `http_allowed_cidr` - CIDR blocks allowed to access HTTP port 80
- `tags` - tags to apply to all resources

## Module outputs

- `instance_id` - ID of the created EC2 instance
- `public_ip` - public IP address of the EC2 instance
- `security_group_id` - ID of the created security group

## How the module is used

This module is consumed by `terraform/day6/env/dev/main.tf`:

```hcl
module "ec2" {
  source = "../../modules/ec2"

  project_name = var.project_name
  environment  = var.environment

  ami_id        = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_id      = module.vpc.vpc_id
  subnet_id   = module.vpc.public_subnet_id
n  my_ip       = var.my_ip
  volume_type = var.volume_type
  volume_size = var.volume_size
}
```

In that environment, the `vpc` module is first created and exposes `vpc_id` and `public_subnet_id`, which the `ec2` module consumes.

## Why this module exists

The EC2 module encapsulates compute provisioning and security configuration so that:

- the network and compute responsibilities remain separated
- the same EC2 deployment logic can be reused for multiple environments
- infrastructure is easier to read and maintain

## Usage note

Because this module creates an internet-facing EC2 instance and SSH access from `my_ip`, use it only in trusted development environments and destroy the deployment when it is no longer needed.