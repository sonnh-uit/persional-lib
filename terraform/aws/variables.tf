variable "server_ami" {
    type = string
    default = "ami-0adfdaea54d40922b" 
    # Input your ami. Example here I use CentOS7
}


variable "instances_type" {
  type = list(string)
  default = ["t2.large","t2.xlarge",  "t3.large"]
  # Input your instance type here

}

variable "region" {
    default = "your_region_here"
}

variable "profile" {
    default = "input your profile name"
}

variable "person-keypair" {
    type = string
    default = "input your public key here"
}