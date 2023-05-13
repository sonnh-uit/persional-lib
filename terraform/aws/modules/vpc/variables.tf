variable "vpc_name" {}
variable "region" {}
variable "role_arn" {
    type = string
    default = "arn:aws:iam::643589119202:role/terraform_ec2_vpc"
}
variable "shared_credentials_files" {}


variable "vpc_cidr_block" {
    type = string
    default = "10.0.0.0/16"
  
}

variable "public_subnet_cidrs" {
    type        = list(string)
    default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "availability_zone" {
    type = string
    default = "ap-southeast-1b"
  
}