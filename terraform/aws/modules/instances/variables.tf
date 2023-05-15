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
    default = "ssh-rsa PyMsJG3vdgWwcqbsava6M5Uyp35yG4%p3QRKdsCvhWvV$#a7ibMu7&oQS6E#^@U*HevJ8QD8UYosaWR$TXuj&*cWhKyGKoB8!Pq@h7st5Z&Q!Q9q5rS%eaGmVcjJZ5dMFmv%!$C2#Pb22r^K!*h4NU9nN78&A!qmuB*DUcEU38copkJq%MkdSY%o5nRD&d^28B#2ypXd9YY#wsvn8x$cJ6MqcC739s$LKWDYyjfhF3rHLe&KnNeHr^oNxe2HiQoexLtBw3jg*RU3DKEumbBZV#jkM^iJ7WfB9qPP$$MEuF9Z@yAGRVMMKKAg4JD#f8R&hci3ggVLczeN3gg*xT##Fbo4Wsg^a#rqLY3^nAHTXDgx8yW37ns3 vagrant@server1"
}