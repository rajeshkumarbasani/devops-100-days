variable "aws_region" {
  description = "AWS region."
  type        = string
  default     = "ap-south-1"
}

variable "availability_zone" {
  description = "Availability Zone."
  type        = string
  default     = "ap-south-1a"
}

variable "project_name" {
  description = "Project name."
  type        = string
  default     = "devops-day8"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "environment must be dev, staging or production."
  }
}

variable "owner" {
  description = "Resource owner."
  type        = string
  default     = "Rajeshkumar Basani"
}

variable "vpc_cidr" {
  description = "VPC CIDR."
  type        = string
  default     = "10.80.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR."
  type        = string
  default     = "10.80.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Optional EC2 key pair name. Set null when using SSM only."
  type        = string
  default     = null
  nullable    = true
}

variable "ssh_allowed_cidrs" {
  description = "CIDRs allowed to connect using SSH. Leave empty for SSM-only access."
  type        = list(string)
  default     = []
}

variable "http_allowed_cidrs" {
  description = "CIDRs allowed to access the application."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "docker_image" {
  description = "Docker Hub image including immutable tag."
  type        = string
}

variable "root_volume_size" {
  description = "Root volume size in GiB."
  type        = number
  default     = 20
}