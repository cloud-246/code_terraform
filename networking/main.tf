resource "aws_vpc" "test_vpc" {
  cidr_block           = var.cidr_block_vpc
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    name = "test_vpc"
  }
}

resource "aws_subnet" "public_1" {
    vpc_id                  = aws_vpc.test_vpc.id
    cidr_block              = var.public_1_cidr_block
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = true

    tags = {
        name = "public_1"
    }
    
}

resource "aws_subnet" "private_1" {
    vpc_id                  = aws_vpc.test_vpc.id
    cidr_block              = var.private_1_cidr_block
    availability_zone       = "us-east-1b"
    map_public_ip_on_launch = true

    tags = {
        name = "private_1"
    }
}

resource "aws_internet_gateway" "igw_test" {
    vpc_id        = aws_vpc.test_vpc.id

    tags = {
        name      = "igw_test"
    }
}

resource "aws_eip" "eip_nat" {
    domain = "vpc"
}

resource "aws_nat_gateway" "test_nat_gw" {
    allocation_id = aws_eip.eip_nat.id
    subnet_id     = aws_subnet.public_1.id
}

resource "aws_route_table" "test_public_rt" {
    vpc_id        = aws_vpc.test_vpc.id

    tags = {
        name      = "test_public_rt"
    }

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw_test.id
    }
}

resource "aws_route_table_association" "public_rt_association" {
    route_table_id = aws_route_table.test_public_rt.id
    subnet_id      = aws_subnet.public_1.id
}


resource "aws_route_table" "private_rt" {
    vpc_id         = aws_vpc.test_vpc.id

    tags = {
        name       = "private_rt"
    }

    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.test_nat_gw.id
    }
}

resource "aws_route_table_association" "private_rt_association" {
    route_table_id =  aws_route_table.private_rt.id
    subnet_id      = aws_subnet.private_1.id
}