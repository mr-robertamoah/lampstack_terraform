variable "vpc_id" {
    type = string
}

variable "ami_id" {
    type = string
}

variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "subnet_id" {
    type = string
}

variable "security_group_ids" {
    type = list(string)
    default = []
}

variable "key_name" {
    type = string
    default = ""
}

variable "tags" {
    type = map(string)
    default = {
        Name = "lampstack-ec2-instance"
        Environment = "sandbox"
    }
  
}

variable "user_data" {
    type = string
    default = ""
}