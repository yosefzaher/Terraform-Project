output "bastion_sg_id" {
    value = aws_security_group.bastion_sg.id
}

output "web_sg_id" {
    value = aws_security_group.web_sg.id
}

output "key_name" {
    value = aws_key_pair.generated_key.key_name
}