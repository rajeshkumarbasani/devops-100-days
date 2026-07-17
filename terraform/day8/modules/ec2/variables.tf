variable "project_name" {
  description = "Project name."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID."
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID."
  type        = string
}

variable "ami_id" {
  description = "EC2 AMI ID."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
}

variable "key_name" {
  description = "Optional EC2 key pair name."
  type        = string
  default     = null
  nullable    = true
}

variable "ssh_allowed_cidrs" {
  description = "CIDR blocks allowed to access SSH."
  type        = list(string)
  default     = []
}

variable "http_allowed_cidrs" {
  description = "CIDR blocks allowed to access the application."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "docker_image" {
  description = "Full Docker image including immutable tag."
  type        = string

  validation {
    condition     = length(trimspace(var.docker_image)) > 0
    error_message = "docker_image must not be empty."
  }
}

variable "application_port" {
  description = "Application port inside the container."
  type        = number
  default     = 3000
}

variable "host_port" {
  description = "Public host port."
  type        = number
  default     = 80
}

variable "root_volume_size" {
  description = "Root EBS volume size in GiB."
  type        = number
  default     = 20

  validation {
    condition     = var.root_volume_size >= 8
    error_message = "root_volume_size must be at least 8 GiB."
  }
}

variable "tags" {
  description = "Additional resource tags."
  type        = map(string)
  default     = {}
}