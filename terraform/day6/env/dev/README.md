cd ~/devops-100-days/terraform/day6/env/dev

# Provision Day 6 Terraform Dev Environment

terraform fmt -recursive
terraform init
terraform validate
terraform plan
terraform apply -auto-approve

# Notes

- `terraform fmt -recursive` formats the configuration files.
- `terraform init` initializes the working directory and downloads modules/providers.
- `terraform validate` checks syntax and configuration correctness.
- `terraform plan` shows the execution plan for the `dev` environment.
- `terraform apply -auto-approve` provisions the infrastructure without interactive approval.
- `terraform destroy -auto-approve` removes the created infrastructure to avoid ongoing costs.

# Clean Up

Use `terraform destroy -auto-approve` when you no longer need this environment. This helps save cloud costs by tearing down resources created for Day 6 development.