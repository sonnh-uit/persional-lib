output "instance_public_ip" {
    description = "The public IP of instace"
    value = module.instances.public_ip
  
}

output "instance_private_ip" {
    description = "The public IP of instace"
    value = module.instances.private_ip
  
}

output "account_id" {
    value = module.iam.account_id
  
}


output "authenticate_list_account" {
    value = module.iam.authenticate_list_account
    sensitive = true
  
}

output "bucket_information" {
    value = module.s3.bucket_information
  
}