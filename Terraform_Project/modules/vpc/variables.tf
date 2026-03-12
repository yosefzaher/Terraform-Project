variable "vpc_cidr" {
    type        = string
    description = "VPC CIDR"
}

variable "bastion_public_subnet_cidr" {
    type = string
    description = "Bastion Host Public Subnet CIDR"
}

variable "public_subnet_cidr" {
    type = string
    description = "Public Subnet CIDR"
}

variable "private_subnet_cidr" {
    type = string
    description = "Private Subnet CIDR"
}

variable "az1" {
    type = string
    default = "us-east-1a"
}

variable "az2" {
    type = string
    default = "us-east-1b"
}