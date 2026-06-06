resource "aws_security_group" "this" {
  name        = "${var.project_name}-${var.environment}-sg"
  description = "Security group for ${var.project_name} in ${var.environment} environment - Day 5 EC2"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-sg"
  })
}

resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.this.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    apt update -y
    apt install docker.io -y
    systemctl enable docker
    systemctl start docker

    cat <<HTML > /tmp/index.html
    <!DOCTYPE html>
    <html>
    <head>
      <title>Day 5 Terraform EC2 Docker</title>
    </head>
    <body>
      <h1>Day 5 App Deployed on AWS EC2</h1>
      <p>Provisioned using Terraform and Docker.</p>
    </body>
    </html>
HTML

    docker run -d \
      --name day5-nginx \
      --restart always \
      -p 80:80 \
      -v /tmp/index.html:/usr/share/nginx/html/index.html \
      nginx:1.27-alpine
  EOF

  root_block_device {
    volume_size           = var.volume_size
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
  }

  metadata_options {
    http_tokens                 = "required"
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 1
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-ec2"
  })
}