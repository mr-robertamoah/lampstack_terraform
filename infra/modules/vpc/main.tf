// vpc, public subnets, private subnets, nat gateways, route tables, security groups, egress only internet gateway 

resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.vpc_name}"
  }
}

resource "aws_subnet" "public_subnet" {
  count = "${length(var.public_subnet_cidrs)}"
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${element(var.public_subnet_cidrs, count.index)}"
  availability_zone = "${element(var.azs, count.index)}"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-public-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  count = "${length(var.public_subnet_cidrs)}"
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${element(var.public_subnet_cidrs, count.index)}"
  availability_zone = "${element(var.azs, count.index)}"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-private-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
  
}

resource "aws_route_table_association" "public_route_table_association" {
  count = "${length(aws_subnet.public_subnet)}"
  subnet_id = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}

resource "aws_nat_gateway" "nat_gateway" {
  subnet_id = "${aws_subnet.public_subnet[0].id}"

  tags = {
    Name = "${var.vpc_name}-nat-gateway"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat_gateway.id}"
  }
}

resource "aws_route_table_association" "private_route_table_association" {
  count = "${length(aws_subnet.private_subnet)}"
  subnet_id = "${element(aws_subnet.private_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.private_route_table.id}"
}

