resource "aws_security_group" "ec2_sg" {
    name = "${var.instance_name}-sg"
    description = "Security Group for EC2"

    ingress {
        description = "Allow SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [var.my_ip/32]
    }

    ingress {
        description = "Allow HTTP"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Allow Jenkins"
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = [var.my_ip/32]
    }

    egress {
        description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.instance_name}-sg"
    }
}
resource "aws_instance" "this" {
    ami           = var.ami_id
    instance_type = var.instance_type
    subnet_id     = var.subnet_id
    vpc_security_group_ids  = [aws_security_group.ec2_sg.id]
    key_name      = var.key_name
    associate_public_ip_address = true

    tags = {
        Name = var.instance_name
    }
}