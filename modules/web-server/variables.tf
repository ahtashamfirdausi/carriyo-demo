variable "vpc_id" {default =  "10.0.0.0/16"}
variable "subnet_id" {default ="10.0.10.0/24" }
variable "env_prefix"{ default = "dev"}
variable "instance_type" {default = "t2.micro" }
variable "avail_zone" {default = "eu-west-2a"}

