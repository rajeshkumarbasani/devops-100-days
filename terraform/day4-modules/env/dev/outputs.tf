output "vpc_id" {
  value = aws_vpc.day4_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.day4_public_subnet.id
}

output "instance_id" {
  value = module.web_server.instance_id
}

output "instance_public_ip" {
  value = module.web_server.public_ip
}

output "security_group_id" {
  value = module.web_server.security_group_id
}