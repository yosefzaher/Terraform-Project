# Create the security group resource for the Bastion Host instance
resource "aws_security_group" "bastion_sg" {
    name        = "bastion_sg"
    description = "Allow SSH inbound traffic"
    vpc_id      = var.vpc_id

    # Ingress (inbound) rule for SSH (Allow From Any IP)
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    # Egress (outbound) rule For Allow Any Traffic of Any Protocol
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# Create the security group resource for the Apache Server instance
resource "aws_security_group" "web_sg" {
    name        = "web_sg"
    description = "Allow SSH inbound traffic from Bastion Host"
    vpc_id = var.vpc_id

    # Ingress (inbound) rule for SSH (Allow From Any Resource Has "bastion_sg")
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        security_groups = [aws_security_group.bastion_sg.id]      
    }
    
    # Egress (outbound) rule For Allow Any Traffic of Any Protocol
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }      
}


# RSA key
resource "tls_private_key" "rsa_key" {
    algorithm = "RSA"
}

# Create Key Pair in AWS
resource "aws_key_pair" "generated_key" {
    key_name   = "ssh-key"
    public_key = tls_private_key.rsa_key.public_key_openssh
}

# Create Secret in Secret Manager
resource "aws_secretsmanager_secret" "ssh_key" {
    name        = "my-ec2-private-key"
    description = "Private key for EC2 instances"
    recovery_window_in_days = 0 
}

# Save The Private Key in The Secret 
resource "aws_secretsmanager_secret_version" "key_value" {
    secret_id     = aws_secretsmanager_secret.ssh_key.id
    secret_string = tls_private_key.rsa_key.private_key_pem
}