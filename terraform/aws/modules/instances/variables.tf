variable "vpc_name" {}
variable "region" {}
variable "role_arn" {}
variable "shared_credentials_files" {}

variable "server_ami" {
    type = string
    default = "ami-062550af7b9fa7d05" 
    # Ubuntu Server 20.04 LTS (HVM)
}


variable "instances_type" {
  type = string
  default = "t2.micro"

}

variable "server_name" {
    type = string
    default = "terraform_test"
  
}

variable "keypair" {
    type = string
    default = "ssh-rsa Bk6zjqsSQ^ANc443twFjDV8Q7DpQ&yctoTqq6fBXsoQwyzjrvoQ@h5D@kcmxn%^DD#kvZUjVkyaAjA@9fRe^Cz%wNDkt25i&YQv2TG!4w4RGtHCiK&AKG2LZa7VcCDbX%XpNKPfSWFF5^#eo#N$cTs$Sr3XMw7%^Nr%3$hA^khyBwvk!GGaeN8N%9W@$9%#R3TpM5X6JSSF5piMVzbhvr^jxa4DwBCJkR&DknD^dwR*ut&SKYAELZ&2poV9AmL&# vagrant@server1"
}