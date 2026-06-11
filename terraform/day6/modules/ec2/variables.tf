variable "project_name" {}
variable "environment" {}
variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "vpc_id" {}
variable "subnet_id" {}
variable "my_ip" {}

variable "volume_size" {
  default = 20
  validation {
    condition     = can(length(var.volume_size) >= 10)
    error_message = "The volume_size value must be more than or equal to 10 gb."
  }
  validation {
    condition     = can(length(var.volume_size) <= 20)
    error_message = "The volume_size value must be less than or equal to 20 gb."
  }
}

variable "volume_type" {
  description = "EBS volume type for EC2 root volume"
  type        = string
  default     = "gp3"

  validation {
    condition = contains(
      ["gp2", "gp3", "io1", "io2", "st1", "sc1", "standard"],
      var.volume_type
    )
    error_message = "Invalid EBS volume type."
  }
}

variable "http_allowed_cidr" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "tags" {
  type    = map(string)
  default = {}
}