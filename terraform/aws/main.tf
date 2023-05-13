module "vpcs" {
    source = "./modules/vpc"

    region = var.region
    role_arn = var.role_arn
    vpc_name = var.vpc_name
    shared_credentials_files = var.shared_credentials_files
  
}

module "instances" {
    source = "./modules/instances"
    depends_on = [ module.vpcs ]

    region = var.region
    role_arn = var.role_arn
    vpc_name = var.vpc_name
    shared_credentials_files = var.shared_credentials_files
  
}

provider "aws" {
    region = var.region
    shared_credentials_files = ["./credentials"]
    assume_role {
        role_arn     = var.role_arn
        session_name = "create_vpc"
    }
}
