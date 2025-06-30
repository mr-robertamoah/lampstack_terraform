variable "vpc_name" {
    type = string
    default = "lampstack-vpc"
}

variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type = list(string)
  default = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "private_subnet_cidrs" {
  type = list(string)
  default = ["10.0.20.0/24", "10.0.21.0/24"]
}

variable "azs" {
  type = list(string)
  default = [ "eu-west-1a", "eu-west-1b" ]
}