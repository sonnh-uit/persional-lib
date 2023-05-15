variable "region" {
    type = string
    default = "ap-southeast-1"
}

variable "role_arn" {
    type = string
    default = "arn:aws:iam::834472459895:role/terraform_test_role"
  
}

variable "vpc_name" {
    type = string
    default = "terraform_test_vpc"
  
}

variable "availability_zone" {
    type = string
    default = "ap-southeast-1b"
  
}