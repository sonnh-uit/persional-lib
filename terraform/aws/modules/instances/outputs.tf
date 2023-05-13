output "arn" {
    description = "Arn of instance"
    value = aws_instance.terraform_server.arn
}

output "public_ip" {
    description = "Instance public IP"
    value = aws_instance.terraform_server.public_ip
}

output "private_ip" {
    description = "Instance private ip"
    value = aws_instance.terraform_server.private_ip
  
}

