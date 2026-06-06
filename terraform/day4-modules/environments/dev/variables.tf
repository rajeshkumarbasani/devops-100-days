variable "aws_region" {}
variable "availability_zone" {}
variable "ami_id" {}
variable "instance_type" {}
variable "instance_name" {}
variable "key_name" {}
variable "my_ip" {}

variable "vpc_cidr" {
    default = "10.20.0.0/16"
}
variable "public_subnet_cidr" {
    default = "10.20.1.0/24"
}
