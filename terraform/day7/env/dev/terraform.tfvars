aws_region        = "ap-south-1"
availability_zone = "ap-south-1a"

project_name = "devops-day7"
environment  = "dev"

ami_id        = "ami-0f58b397bc5c1f2e8"
instance_type = "t2.micro"

my_ip    = "13.202.136.205/32"
key_name = "server-cp"

docker_image = "raj358822/day7-nginx-app:latest"

vpc_cidr           = "10.70.0.0/16"
public_subnet_cidr = "10.70.1.0/24"
volume_size        = 20