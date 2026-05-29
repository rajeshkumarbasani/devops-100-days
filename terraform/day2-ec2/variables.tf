variable "aws_region"{
    default = "ap-south-1"
    description = "AWS region for all resources"
}

variable "ami_id"{
    default = "ami-0f58b397bc5c1f2e8"
    description = "AMI ID for EC2 instance"
}

variable "instance_type"{
    default = "t2.micro"
    description = "EC2 instance type"
}
variable "vpc_cidr_block"{
    default = "10.0.0.0/16"
    description = "VPC CIDR block"
}
variable "subnet_cidr_block"{
    default = "10.0.1.0/24"
}
