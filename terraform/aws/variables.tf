variable "region" {
    type = string
    default = "ap-southeast-1"
}

variable "role_arn" {
    type = string
    default = "arn:aws:iam::899795251363:role/terraform_test_role"
  
}

variable "vpc_name" {
    type = string
    default = "terraform_test_vpc"
  
}

variable "availability_zone" {
    type = string
    default = "ap-southeast-1b"
  
}

variable "ops_list_username" {
    type = list(string)
    default = [ "ops_lincoln", "ops_trump", "ops_roosevelt" ]
  
}

variable "bucket_name_prefix" {
    type = string
    default = "998-example-bucket-name"
  
}