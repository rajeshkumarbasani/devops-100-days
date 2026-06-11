terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Day 6 uses local state.
  # Day 7 will upgrade this to S3 remote backend + DynamoDB locking.
}