terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

provider "aws" {
    region  = var.region
    profile = var.profile
    shared_credentials_files = ["./credentials"]
}

# key_pair create first time. Then you must comment this resource
resource "aws_key_pair" "person-keypair" {
  key_name    = "your_key_pair_name"
  public_key  = var.person-keypair
}

resource "aws_instance" "server" {
  for_each = toset(var.instances_type)
  ami           = var.server_ami
  instance_type = each.value
  key_name      = "your_key_pair_name"
  tags = {
    "Name" = "server-${each.value}"
    # Input your instance name (this is not hostname in server). Here I use name with prefix server and last is instance type
  }
  user_data = file("startup-script")
  root_block_device {
    delete_on_termination = true
    volume_size           = 100
    volume_type           = "gp2"
    tags = {
      "Name" = "server-${each.value}"
    }
  }
}