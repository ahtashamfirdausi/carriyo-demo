provider "aws" {

    region = "eu-west-2"

}

resource "aws_vpc" "carriyo-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name:  "${var.env_prefix}-vpc"
    } 
}


module "carriyo-subnet" {
  source = "./modules/network"
  subnet_crid_block = var.subnet_crid_block
  avail_zone = var.avail_zone
  env_prefix = var.env_prefix
  vpc_id = aws_vpc.carriyo-vpc.id
  aws_route_table =aws_vpc.carriyo-vpc.aws_route_table_id
}

module "carriyo-server"{
     source = "./modules/web-server"
     vpc_id = aws_vpc.carriyo-vpc.id
     env_prefix = var.env_prefix
     instance_type = var.instance_type
     subnet_id = module.carriyo-subnet.subnet.id
     avail_zone = var.avail_zone

}