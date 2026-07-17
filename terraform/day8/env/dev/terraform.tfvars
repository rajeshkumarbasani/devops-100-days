aws_region        = "ap-south-1"
availability_zone = "ap-south-1a"

project_name = "devops-day8"
environment  = "dev"
owner        = "Rajeshkumar Basani"

vpc_cidr           = "10.80.0.0/16"
public_subnet_cidr = "10.80.1.0/24"

instance_type    = "t3.micro"
key_name         = null
root_volume_size = 20

ssh_allowed_cidrs = []

http_allowed_cidrs = [
  "0.0.0.0/0"
]

docker_image = "raj358822/day8-node-app:manual"