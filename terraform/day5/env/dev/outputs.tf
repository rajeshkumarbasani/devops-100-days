output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "ec2_instance_id" {
  value = module.ec2.instance_id
}

output "ec2_public_ip" {
  value = module.ec2.public_ip
}

output "application_url" {
  value = "http://${module.ec2.public_ip}"
}

output "security_group_id" {
  value = module.ec2.security_group_id
}