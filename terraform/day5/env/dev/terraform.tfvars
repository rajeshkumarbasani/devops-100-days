aws_region        = "ap-south-1"
availability_zone = "ap-south-1a"

project_name = "devops-day5"
environment  = "dev"

ami_id        = "ami-0f58b397bc5c1f2e8"
instance_type = "t2.micro"

key_name = "YOUR_KEY_PAIR_NAME"
my_ip    = "YOUR_PUBLIC_IP/32"

vpc_cidr           = "10.50.0.0/16"
public_subnet_cidr = "10.50.1.0/24"
volume_size        = 20