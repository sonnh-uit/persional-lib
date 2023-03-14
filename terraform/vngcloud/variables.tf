variable "client_id" {
    type = string
    default = "your_client_id"
}

variable "client_secret" {
    type = string
    default = "your_client_secret"
}

variable "project_id" {
    type = string
    default = "pro-4be0ec1a-d783-4814-8190-ba354616366a"
}

variable "flavor_id" {
    type = map
    default = {
        "micro" = "flav-your_flavor_id"
        "xlarge" = "flav-your_flavor_id"
        "2xlarge" = "flav-your_flavor_id"
        # Because server configuration id of vng cloud not design for human understand, I use some definition design by AWS
    } 
    
}

variable "image_id" {
    type = map
    default = {
        "centos7-6" = "img-your_img_id_here"
        "centos6-10" = "img-your_img_id_here"
        "centos7-9" = "img-your_img_id_here"
    }
    # Because img id of vng cloud not design for human understand, I use some definition design by AWS
}


variable "network_id" {
    type = string
    default = "net-your_network_id"
}

variable "disk_iops" {
    type = string
    default = "3000"
}

variable "ssh_key" {
    type = string
    default = "ssh-your_ssh_key_id"
}

variable "user_name" {
    type = string
    default = "your_username_here"
}

variable "user_password" {
    type = string
    default = "your_user_password"
}


variable "security_group" {
    type = map
    default = {
        "default" = "secg-your_security_group_id"
        "web_server" = "secg-your_security_group_id"
    }
}

variable "subnet_id" {
    type = map
    default = {
        "localtest" = "sub-your_subnet_id"
        "staging" = "sub-your_subnet_id"
        "production" = "sub-your_subnet_id"
    }
}

variable "server_name" {
    type = list(string)
    default = ["centos7-6","centos6-10","centos7-9"]
}