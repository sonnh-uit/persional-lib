resource "aws_vpc" "terraform_test_vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        "Name" = var.vpc_name
    }
  
}

# resource "aws_subnet" "private_subnet" {
#     count = length(var.private_subnet_cidrs)
#     vpc_id = aws_vpc.terraform_test_vpc.id
#     cidr_block = element(var.private_subnet_cidrs, count.index)
#     availability_zone = var.availability_zone

#     tags = {
#         "Name" = "private_subnet_${count.index + 1}"
#     }
  
# }

resource "aws_subnet" "public_subnet" {
    count = length(var.public_subnet_cidrs)
    vpc_id = aws_vpc.terraform_test_vpc.id
    cidr_block = element(var.public_subnet_cidrs, count.index)
    availability_zone = var.availability_zone
    map_public_ip_on_launch = true

    tags = {
        "Name" = "public_subnet_${count.index + 1}"
    }
  
}

resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = aws_vpc.terraform_test_vpc.id

    tags = {
        "Name" = "Terraform_IG"
    }
  
}

resource "aws_route_table" "internet_route" {
    vpc_id = aws_vpc.terraform_test_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet_gateway.id
    }

    tags = {
        Name = "Internet route table"
    }
  
}

resource "aws_route_table_association" "public_route_associate" {
    count = length(var.public_subnet_cidrs)
    subnet_id = element(aws_subnet.public_subnet[*].id, count.index)
    route_table_id = aws_route_table.internet_route.id
  
}

resource "aws_security_group" "default_seg" {
    name = "default_seg"
    description = "This is main seg"
    vpc_id = aws_vpc.terraform_test_vpc.id

    ingress {
        description = "SSH to server"
        from_port = 22
        to_port = 22
        protocol = "tcp"

        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "default_seg"
    }
  
}

resource "aws_security_group_rule" "http" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

    security_group_id = aws_security_group.default_seg.id
  
}

resource "aws_security_group_rule" "https" {
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

    security_group_id = aws_security_group.default_seg.id
  
}

resource "aws_security_group_rule" "egress" {
    type = "egress"
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

    security_group_id = aws_security_group.default_seg.id
  
}


resource "aws_network_interface" "terrafrom_network_interface" {
    count = length(var.public_subnet_cidrs)
    subnet_id = element(aws_subnet.public_subnet[*].id, count.index)
    security_groups = [aws_security_group.default_seg.id]
    ipv4_prefix_count = 2

    tags = {
        Name = "network_interface_${count.index + 1}"
    }
}

