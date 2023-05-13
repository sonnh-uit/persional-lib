output "instance_public_ip" {
    description = "The public IP of instace"
    value = module.instances.public_ip
  
}

output "instance_private_ip" {
    description = "The public IP of instace"
    value = module.instances.private_ip
  
}