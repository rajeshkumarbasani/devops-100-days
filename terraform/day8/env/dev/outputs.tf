output "vpc_id" {
  description = "VPC ID."
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "Public subnet ID."
  value       = module.vpc.public_subnet_id
}

output "instance_id" {
  description = "EC2 instance ID."
  value       = module.ec2.instance_id
}

output "public_ip" {
  description = "EC2 public IP."
  value       = module.ec2.public_ip
}

output "public_dns" {
  description = "EC2 public DNS."
  value       = module.ec2.public_dns
}

output "application_url" {
  description = "Application URL."
  value       = "http://${module.ec2.public_ip}"
}

output "health_url" {
  description = "Application readiness endpoint."
  value       = "http://${module.ec2.public_ip}/health/ready"
}

output "ssm_command" {
  description = "Command for opening an SSM session."
  value       = "aws ssm start-session --target ${module.ec2.instance_id} --region ${var.aws_region}"
}

output "deployed_docker_image" {
  description = "Immutable Docker image deployed to EC2."
  value       = var.docker_image
}