variable "vpc_name" {}
variable "region" {}
variable "availability_zone" {}

variable "server_ami" {
    type = string
    default = "ami-062550af7b9fa7d05" 
    # Ubuntu Server 20.04 LTS (HVM)
}


variable "instances_type" {
  type = string
  default = "t2.micro"
  # Input your instance type here

}

variable "server_name" {
    type = string
    default = "terraform_test"
  
}

variable "keypair" {
    type = string
    default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8mhLODwa7qWIOnm1uEmuq4788GMTCX2kcFgCB/UMD87Vm0wtqaBGSy9EwpfUbaWifHtXH+P3JY0vNgxAibQn2j4PDHILkg9zrR81FzTcBCPeBvc+vEqlNWCTtBWAGb19WMMNzfj7DMFxP6aV2H9pgHUkiHhFLOyyC1WnGjeusl6j9lt+9s9G0BOQ0iPFLkRoWFZjYbSBOa1CNJTTQFB+tRh44M2nXhkam3Zn0GtMD27T5jwz6a+8NwhKE1M2uoFCWvTNX0t/R72DkPe3ztjq8Zj5/sL+4E3BLX+OK9eQf1/10v2iDWqGeICx6WwUYlIesr9a4P2Vx7p0usd+cjAHF vagrant@server1"
}