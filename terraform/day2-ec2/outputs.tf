output "instance_id" {
    value = aws_instance.day2_ec2.id
}

output "public_id" {
    value = aws_instance.day2_ec2.public_ip
}