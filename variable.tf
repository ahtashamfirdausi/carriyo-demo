variable "vpc_cidr_block"{ default =  "10.0.0.0/16"}
variable "subnet_crid_block"{default = "10.0.10.0/20"}
variable "avail_zone" {default = "eu-west-1a"}
variable "env_prefix"{ default = "dev"}
variable "instance_type" {default = "t2.micro" }