variable "aws_region" {}
variable "availability_zone" {}
variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "my_ip" {}

variable "vpc_cidr" {
  default = "10.10.0.0/16"
}
variable "public_subnet_cidr" {
  default = " 10.10.1.0/24"
}
variable "private_subnet_cidr" {
  default = "10.10.2.0/24"
}