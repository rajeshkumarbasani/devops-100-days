variable "project_name" {}
variable "environment" {}
variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "vpc_id" {}
variable "subnet_id" {}
variable "my_ip" {}
variable "docker_image" {}

variable "volume_size" {
  default = 20
}

variable "http_allowed_cidr" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "tags" {
  type    = map(string)
  default = {}
}