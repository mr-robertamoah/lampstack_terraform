output "vpc_id" {
  value = aws_vpc.vpc.id
}

# output public subnets
output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}

# output private subnets
output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}

output "vpc_name" {
  value = var.vpc_name
}