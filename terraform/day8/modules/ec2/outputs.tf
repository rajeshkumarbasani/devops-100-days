output "instance_id" {
  description = "EC2 instance ID."
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "EC2 public IPv4 address."
  value       = aws_instance.this.public_ip
}

output "public_dns" {
  description = "EC2 public DNS hostname."
  value       = aws_instance.this.public_dns
}

output "security_group_id" {
  description = "Application security group ID."
  value       = aws_security_group.this.id
}

output "iam_role_name" {
  description = "EC2 IAM role name."
  value       = aws_iam_role.ec2.name
}