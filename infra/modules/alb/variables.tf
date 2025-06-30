variable "vpc_name" {
  type    = string
  default = "lampstack-vpc"
}

variable "security_group_ids" {
  type = list(string)
  default = []
}

variable "subnet_ids" {
  type = list(string)
  default = []
}

variable "vpc_id" {
  type = string
  default = ""
}

variable "instance_id" {
  type = string
  default = ""
}