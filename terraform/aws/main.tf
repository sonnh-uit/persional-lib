module "vpcs" {
    source = "./modules/vpc"

    region = var.region
    vpc_name = var.vpc_name
    availability_zone = var.availability_zone
  
}

module "instances" {
    source = "./modules/instances"
    depends_on = [ module.vpcs ]

    region = var.region
    vpc_name = var.vpc_name
    availability_zone = var.availability_zone
  
}

provider "aws" {
    region = var.region
    shared_credentials_files = ["./credentials"]
    assume_role {
        role_arn     = var.role_arn
        session_name = "create_vpc"
    }
}
