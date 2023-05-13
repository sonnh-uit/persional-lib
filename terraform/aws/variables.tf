variable "region" {
    type = string
    default = "ap-southeast-1"
}

variable "role_arn" {
    type = string
    default = "arn:aws:iam::726694885256:role/terraform_ec2_vpc"
  
}

variable "vpc_name" {
    type = string
    default = "terraform_test_vpc"
  
}

variable "shared_credentials_files" {
    default = "../../credentials"
  
}
