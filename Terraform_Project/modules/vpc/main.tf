# Create The VPC
resource "aws_vpc" "vpc" {
    cidr_block       = var.vpc_cidr
    enable_dns_hostnames = true  

    tags = {
        Name = "infra-vpc"
    }
}

# Create The Public Subnet That Bastion Host Will Be in
resource "aws_subnet" "bastion_public_subnet" {
    vpc_id     = aws_vpc.vpc.id
    cidr_block = var.bastion_public_subnet_cidr
    availability_zone = var.az1
    map_public_ip_on_launch = true
    
    tags = {
        Name = "bastion_public_subnet"
    }
}

# Create The Public Subnet That NAT Gateway Will Be in
resource "aws_subnet" "public_subnet" {
    vpc_id     = aws_vpc.vpc.id
    cidr_block = var.public_subnet_cidr
    map_public_ip_on_launch = true
    availability_zone = var.az2

    tags = {
        Name = "public_subnet"
    }
}

# Create The Private Subnet That Apache Server Will Be in
resource "aws_subnet" "private_subnet" {
    vpc_id     = aws_vpc.vpc.id
    cidr_block = var.private_subnet_cidr
    availability_zone = var.az1
    
    tags = {
        Name = "private_subnet"
    }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name = "igw"
    }
}

# Allocate a static Elastic IP for the NAT Gateway
resource "aws_eip" "nat_gw_eip" {
    domain = "vpc"
    tags = {
        Name = "nat-gw-eip"
    }

    depends_on = [aws_internet_gateway.igw] 
}

# Create NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
    allocation_id = aws_eip.nat_gw_eip.id
    subnet_id     = aws_subnet.public_subnet.id

    tags = {
        Name = "nat_gw"
    }

    depends_on = [aws_internet_gateway.igw]
}

# Create Public Route Table
resource "aws_route_table" "public_rtb" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "public-route-table"
    }
}

# Route The Traffic to IGW
resource "aws_route" "public_internet_route" {
    route_table_id         = aws_route_table.public_rtb.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.igw.id
}

# Associate The Table to The Public Subnets
resource "aws_route_table_association" "public_association1" {
    subnet_id      = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_rtb.id
}

resource "aws_route_table_association" "public_association2" {
    subnet_id      = aws_subnet.bastion_public_subnet.id
    route_table_id = aws_route_table.public_rtb.id
}

# Create Private Route Table
resource "aws_route_table" "private_rtb" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "private-route-table"
    }
}

# Route The Traffic to NGW
resource "aws_route" "private_internet_route" {
    route_table_id         = aws_route_table.private_rtb.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_nat_gateway.nat_gw.id
}

# Associate The Table to The Public Subnets
resource "aws_route_table_association" "private_association" {
    subnet_id      = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.private_rtb.id
}