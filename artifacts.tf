resource "aws_key_pair" "deployment" {
  key_name   = "epifi_key_pair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDRovAxwLw4fdHsh7NXjyVM/TArx8/nQLmz/KfJRDOCI/DfU7xiTdfay/PgD5ZwMKVXyYlBAseBWZUmV1iUKu+GQJQBDbzU01nmWdt3IzJ540XZO5BdlkDIMgicPtfGAzT7YDkkE1GUGe5wWM8tcuaEaYOSgwKbEv8DKoUxcwN+9D67AkGIJ83HAXlbHIhiwZYn1l8GWRTHUWCiDQvp+v1PnM7/U54iQpKYT5ArjrqbfNGX5JMQVcZ3svLJNfY2nk9ryN6j+Xf9kUe3J6NXY5+69dzveHMX59iFY7lr5Bx88/7j04ZGJgTt47kFdxCCfO6Bvux66DPqBLbPN4PkyY95 abhilash@abhilash-bolla"
}

resource "aws_vpc" "vpc" {
  cidr_block       = "${var.vpc_cidr_map[terraform.workspace]}"
  instance_tenancy = "default"
  tags = {
    Name        = "${terraform.workspace} VPC Epifi"
    Environment = "${terraform.workspace}"
    Creator     = "Terraform"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags = {
    Name        = "Main Internet Gateway Epifi"
    Environment = "${terraform.workspace}"
    Creator     = "Terraform"
  }
}

resource "aws_eip" "nat" {
  vpc = true
  tags = {
    Name        = "Main ${terraform.workspace} NAT Public IP"
    Environment = "${terraform.workspace}"
    Creator     = "Terraform"
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.public_subnet.id}"

  tags = {
    Name        = "Main NAT Gateway"
    Environment = "${terraform.workspace}"
    Creator     = "Terraform"
  }
}

resource "aws_route_table" "igw_rt" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags = {
    Name        = "${terraform.workspace} Internet Gateway Route Table"
    Environment = "${terraform.workspace}"
    Creator     = "Terraform"
  }
}

resource "aws_route_table" "nat_rt_1" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.ngw.id}"
  }

  tags = {
    Name        = "${terraform.workspace} NAT Gateway Route Table 1"
    Environment = "${terraform.workspace}"
    Creator     = "Terraform"
  }
}

resource "aws_route_table" "nat_rt_2" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.ngw.id}"
  }

  tags = {
    Name        = "${terraform.workspace} NAT Gateway Route Table 2"
    Environment = "${terraform.workspace}"
    Creator     = "Terraform"
  }
}


resource "aws_subnet" "public_subnet" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.public_subnet_map[terraform.workspace]}"
  availability_zone = "ap-south-1a"
  depends_on        = ["aws_internet_gateway.igw"]

  tags = {
    Name        = "Main ${terraform.workspace} Public Subnet"
    Environment = "${terraform.workspace}"
    Creator     = "Terraform"
  }
}


resource "aws_subnet" "private_subnet_1" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.private_subnet_map_1[terraform.workspace]}"
  availability_zone = "ap-south-1a"

  tags = {
    Name        = "Main ${terraform.workspace} Private Subnet 1"
    Environment = "${terraform.workspace}"
    Creator     = "Terraform"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.private_subnet_map_2[terraform.workspace]}"
  availability_zone = "ap-south-1b"

  tags = {
    Name        = "Main ${terraform.workspace} Private Subnet 2"
    Environment = "${terraform.workspace}"
    Creator     = "Terraform"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = "${aws_subnet.public_subnet.id}"
  route_table_id = "${aws_route_table.igw_rt.id}"
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = "${aws_subnet.private_subnet_1.id}"
  route_table_id = "${aws_route_table.nat_rt_1.id}"
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = "${aws_subnet.private_subnet_2.id}"
  route_table_id = "${aws_route_table.nat_rt_2.id}"
}