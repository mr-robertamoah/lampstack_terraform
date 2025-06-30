variable "vpc_name" {
    type = string
    default = "lampstack-vpc"
}

variable "vpc_id" {
    type = string
}

variable "public_key" {
    type = string
    description = "The public key to be used for the bastion host."
}