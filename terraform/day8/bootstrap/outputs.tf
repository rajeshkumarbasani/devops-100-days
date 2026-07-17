output "state_bucket_name" {
  description = "Terraform state S3 bucket name."
  value       = aws_s3_bucket.terraform_state.bucket
}

output "state_bucket_region" {
  description = "Terraform state S3 bucket region."
  value       = var.aws_region
}