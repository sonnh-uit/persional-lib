module "iam" {
    source = "./modules/iams"

    ops_list_username = var.ops_list_username
  
}

module "vpcs" {
    source = "./modules/vpc"

    region = var.region
    vpc_name = var.vpc_name
    availability_zone = var.availability_zone
  
}

module "instances" {
    source = "./modules/instances"
    depends_on = [ module.vpcs, module.iam ]
    
    region = var.region
    vpc_name = var.vpc_name
    availability_zone = var.availability_zone
  
}



module "s3" {
    source = "./modules/s3"

    bucket_name_prefix = var.bucket_name_prefix
  
}

provider "aws" {
    region = var.region
    shared_credentials_files = ["./credentials"]
    assume_role {
        role_arn     = var.role_arn
        session_name = "create_vpc"
    }
}
