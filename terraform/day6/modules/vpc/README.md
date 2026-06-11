# VPC Module

This Terraform module provision a basic AWS networking stack for Day 6.
It creates a VPC, a public subnet, an internet gateway, a public route table, and a route table association.

## What the module creates

- `aws_vpc.this`
  - Creates the VPC with DNS hostnames and DNS support enabled.
- `aws_subnet.public`
  - Creates a public subnet in the specified availability zone and assigns public IPs on launch.
- `aws_internet_gateway.this`
  - Creates an internet gateway attached to the VPC.
- `aws_route_table.public`
  - Creates a route table with a default route to the internet gateway.
- `aws_route_table_association.public`
  - Associates the public subnet with the public route table.

## Module inputs

- `project_name` - used for naming resources.
- `environment` - used for naming resources.
- `vpc_cidr` - CIDR block for the VPC.
- `public_subnet_cidr` - CIDR block for the public subnet.
- `availability_zone` - availability zone for the public subnet.
- `tags` - common tags applied to all resources.

## Module outputs

- `vpc_id` - ID of the created VPC.
- `public_subnet_id` - ID of the created public subnet.

## Where it is used

This module is used by `terraform/day6/env/dev/main.tf`:

```hcl
module "vpc" {
  source = "../../modules/vpc"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = var.availability_zone
  tags               = local.common_tags
}
```

The output values from this module are consumed by the EC2 module in the same environment:

- `module.vpc.vpc_id`
- `module.vpc.public_subnet_id`

## Why this module exists

Using a dedicated VPC module separates network provisioning from compute provisioning.
That makes the architecture reusable, easier to understand, and easier to maintain across environments.