variable "project_name" { type = string }
variable "environment" { type = string }
variable "vpc_id" { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "private_subnet_ids" { type = list(string) }
variable "container_image" { type = string }
variable "container_port" { 
    type = number
    default = 3000 
}
variable "desired_count" { 
    type = number
    default = 2 
}
variable "task_cpu" { 
    type = number
    default = 256 
    }
variable "task_memory" { 
    type = number 
    default = 512 
    }
variable "min_capacity" { 
    type = number 
    default = 2 
    }
variable "max_capacity" { 
    type = number 
    default = 4 
    }
variable "cpu_target_value" { 
    type = number 
    default = 60 
    }
variable "memory_target_value" { 
    type = number 
    default = 70 
    }
variable "log_retention_days" {
    type = number
    default = 14
    }
variable "health_check_path" { 
    type = string
    default = "/health/ready"
    }
variable "tags" { 
    type = map(string)
    default = {}
     }
