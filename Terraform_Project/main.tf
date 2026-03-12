module "vpc" {
    source = "./modules/vpc"

    vpc_cidr = var.vpc_cidr
    bastion_public_subnet_cidr = var.bastion_public_subnet_cidr
    public_subnet_cidr = var.public_subnet_cidr
    private_subnet_cidr = var.private_subnet_cidr
}

module "security" {
    source = "./modules/security"
    vpc_id = module.vpc.vpc_id
}

module "ec2" {
    source = "./modules/ec2"
    bastion_sg_id = module.security.bastion_sg_id
    web_sg_id = module.security.web_sg_id
    instance_type = var.instance_type
    key_name = module.security.key_name
    bastion_subnet_id = module.vpc.bastion_public_subnet_id
    web_subnet_id = module.vpc.private_subnet_id
}