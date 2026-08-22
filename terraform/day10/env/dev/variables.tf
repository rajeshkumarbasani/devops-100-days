variable "aws_region" { type=string; default="ap-south-1" }
variable "environment" { type=string; default="dev" }
variable "project_name" { type=string; default="devops-day10" }
variable "container_image" { type=string; default="raj358822/day10-app:manual" }
variable "vpc_cidr" { type=string; default="10.30.0.0/16" }
variable "availability_zones" { type=list(string); default=["ap-south-1a","ap-south-1b"] }
variable "public_subnet_cidrs" { type=list(string); default=["10.30.1.0/24","10.30.2.0/24"] }
variable "private_subnet_cidrs" { type=list(string); default=["10.30.11.0/24","10.30.12.0/24"] }
