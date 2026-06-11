variable "aws_region" {}
variable "availability_zone" {}
variable "project_name" {}
variable "environment" {}
variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "my_ip" {}

variable "vpc_cidr" {
    default = "10.60.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.60.1.0/24"
}

variable "volume_size"{
    default = 20
}

variable "volume_type"{
    default = "gp3"
}



