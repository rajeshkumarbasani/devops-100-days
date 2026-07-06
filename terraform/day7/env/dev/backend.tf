terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Day 7 local backend.
  # Day 8 upgrade: S3 backend + DynamoDB locking.
}