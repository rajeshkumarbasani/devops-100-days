variable "project_name" {}
variable "environment" {}
variable "vpc_cidr" {}
variable "public_subnet_cidr" {}
variable "availability_zone" {}

variable "tags" {
    type = map(string)
    default = {}
}