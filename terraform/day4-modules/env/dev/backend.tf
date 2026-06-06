terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # For Day 4 local state is okay.
  # Later we will move this to S3 + DynamoDB locking.
}