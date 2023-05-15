variable "vpc_name" {}
variable "region" {}
variable "availability_zone" {}

variable "vpc_cidr_block" {
    type = string
    default = "10.0.0.0/16"
  
}

variable "public_subnet_cidrs" {
    type        = list(string)
    default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
    type        = list(string)
    default     = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
}


variable "internet_gateway_name" {
    type = string
    default = "public_internet_gateway"
  
}

variable "internet_route_name" {
    type = string
    default = "internet_route_table"
  
}