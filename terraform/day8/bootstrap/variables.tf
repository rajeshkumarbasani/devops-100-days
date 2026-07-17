variable "aws_region" {
  description = "AWS region for the Terraform state bucket."
  type        = string
  default     = "ap-south-1"
}

variable "state_bucket_name" {
  description = "Globally unique S3 bucket name for Terraform state."
  type        = string

  validation {
    condition = (
      length(var.state_bucket_name) >= 3 &&
      length(var.state_bucket_name) <= 63
    )

    error_message = "The S3 bucket name must contain between 3 and 63 characters."
  }
}

variable "project_name" {
  description = "Project name used for resource tags."
  type        = string
  default     = "devops-100-days"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "shared"
}