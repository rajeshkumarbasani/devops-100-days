resource "aws_security_group" "this" {
  name_prefix = "${var.project_name}-${var.environment}-"
  description = "Security group for the Day 8 application"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = length(var.ssh_allowed_cidrs) > 0 ? [1] : []

    content {
      description = "Restricted SSH access"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.ssh_allowed_cidrs
    }
  }

  ingress {
    description = "Application HTTP access"
    from_port   = var.host_port
    to_port     = var.host_port
    protocol    = "tcp"
    cidr_blocks = var.http_allowed_cidrs
  }

  egress {
    description = "Allow outbound IPv4 traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-application-sg"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "ec2" {
  name = "${var.project_name}-${var.environment}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2" {
  name = "${var.project_name}-${var.environment}-ec2-profile"
  role = aws_iam_role.ec2.name
}

resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.this.id]

  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2.name

  user_data_replace_on_change = true

  user_data = templatefile("${path.module}/user_data.sh.tpl", {
    docker_image     = var.docker_image
    application_port = var.application_port
    host_port        = var.host_port
    container_name   = "${var.project_name}-${var.environment}-app"
  })

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size
    encrypted             = true
    delete_on_termination = true

    tags = merge(var.tags, {
      Name = "${var.project_name}-${var.environment}-root-volume"
    })
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  monitoring = true

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-ec2"
  })

  lifecycle {
    create_before_destroy = true

    precondition {
      condition     = var.host_port >= 1 && var.host_port <= 65535
      error_message = "host_port must be between 1 and 65535."
    }

    precondition {
      condition     = var.application_port >= 1 && var.application_port <= 65535
      error_message = "application_port must be between 1 and 65535."
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.ssm
  ]
}