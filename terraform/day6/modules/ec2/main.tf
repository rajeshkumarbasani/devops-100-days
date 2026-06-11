resource "aws_security_group" "this" {
  name        = "${var.project_name}-${var.environment}-sg"
  description = "Day 6 EC2 security group"

  vpc_id = var.vpc_id

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]

  }

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.http_allowed_cidr

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
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.this.id]
  associate_public_ip_address = true

  user_data_replace_on_change = true

  user_data = <<-EOF
    #!/bin/bash
    set -xe

    apt update -y
    apt install -y docker.io
    systemctl enable docker
    systemctl start docker

    mkdir -p /opt/day6-app

    cat > /opt/day6-app/index.html <<'HTML'
    <!DOCTYPE html>
    <html>
    <head>
      <title>Day 6 Terraform Docker App</title>
    </head>
    <body>
      <h1>Day 6 App Running on EC2</h1>
      <p>Provisioned with Terraform module and Docker.</p>
    </body>
    </html>
HTML

    docker rm -f day6-nginx || true

    docker run -d \
      --name day6-nginx \
      --restart unless-stopped \
      -p 80:80 \
      -v /opt/day6-app/index.html:/usr/share/nginx/html/index.html:ro \
      nginx:1.27-alpine
  EOF

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
    encrypted   = true
  }

  metadata_options {
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  monitoring = true

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-ec2"
  })
}