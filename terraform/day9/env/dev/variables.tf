variable "aws_region" {
  type    = string
  default = "ap-south-1"
}
variable "project_name" {
  type    = string
  default = "devops-day9"
}
variable "environment" {
  type    = string
  default = "dev"
}
variable "owner" {
  type    = string
  default = "Rajeshkumar Basani"
}
variable "vpc_cidr" {
  type    = string
  default = "10.90.0.0/16"
}
variable "availability_zones" {
  type    = list(string)
  default = ["ap-south-1a", "ap-south-1b"]
}
variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.90.1.0/24", "10.90.2.0/24"]
}
variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.90.11.0/24", "10.90.12.0/24"]
}
variable "single_nat_gateway" {
  type    = bool
  default = true
}
variable "container_image" {
  type = string
}
variable "desired_count" {
  type    = number
  default = 2
}
variable "min_capacity" {
  type    = number
  default = 2
}
variable "max_capacity" {
  type    = number
  default = 4
}
