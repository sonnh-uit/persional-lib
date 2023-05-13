data "aws_vpc" "vpc_name" {
    filter {
        name = "tag:Name"
        values = [var.vpc_name]
    }
  
}

data "aws_subnet" "public_subnet_1" {
    vpc_id = data.aws_vpc.vpc_name.id

    filter {
        name = "tag:Name"
        values = ["*public*"]
    }

    filter {
        name = "tag:Name"
        values = ["*subnet_1"]
    }

}


data "aws_security_groups" "default_seg" {

    filter {
        name = "vpc-id"
        values = [data.aws_vpc.vpc_name.id]
    }

    filter {
        name = "tag:Name"
        values = ["default_seg"]
    }
}


data "aws_network_interface" "network_interface_1" {
    filter {
        name = "tag:Name"
        values = ["*_interface_1"]
    }
  
}

resource "aws_key_pair" "personal_keypair" {
    key_name = "personal_keypair"
    public_key = var.keypair
  
}


resource "aws_instance" "terraform_server" {
    ami = var.server_ami
    instance_type = var.instances_type
    key_name = aws_key_pair.personal_keypair.key_name

    tags = {
        "Name" = var.server_name
    }

    root_block_device {
        delete_on_termination = true
        volume_size           = 20
        volume_type           = "gp2"
        tags = {
            "Name" = "terraform-testserver-boot"
        }
    }

    network_interface {
        network_interface_id = data.aws_network_interface.network_interface_1.id
        device_index = 0
    }
}
