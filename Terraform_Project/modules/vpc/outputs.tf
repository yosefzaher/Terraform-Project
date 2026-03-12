output "vpc_id" {
    value = aws_vpc.vpc.id
    description = "The ID of the VPC."
}   

output "bastion_public_subnet_id" {
    value = aws_subnet.bastion_public_subnet.id
    description = "The ID of the Subnet that Bastion Host is in."
}

output "public_subnet_id" {
    value = aws_subnet.public_subnet.id
    description = "The ID of the Subnet that NAT Gateway is in."
}

output "private_subnet_id" {
    value = aws_subnet.private_subnet.id
    description = "The ID of the Subnet that Apache Server is in."
}

