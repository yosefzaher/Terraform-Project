# Create an EC2 instance for Bastion Host
resource "aws_instance" "bastion_host" {
    ami           = data.aws_ami.ubuntu.id
    instance_type = var.instance_type 

    # Associate the security group
    vpc_security_group_ids = [var.bastion_sg_id]
    subnet_id = var.bastion_subnet_id
    key_name = var.key_name

    tags = {
        Name = "bastion_host"
    }
}

# Create an EC2 instance for Apache Server
resource "aws_instance" "apache_server" {
    ami           = data.aws_ami.ubuntu.id
    instance_type = var.instance_type 

    # Associate the security group
    vpc_security_group_ids = [var.web_sg_id]
    subnet_id = var.web_subnet_id
    key_name = var.key_name

    tags = {
        Name = "web_server"
    }
}