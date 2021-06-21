provider "aws" {

    region = "eu-west-1"

}
variable "vpc_cidr_block"{ default =  "10.0.0.0/16"}
variable "subnet_crid_block"{default = "10.0.10.0/20"}
variable "avail_zone" {default = "eu-west-1a"}
variable "env_prefix"{ default = "dev"}
variable "instance_type" {default = "t2.micro" }
/*
resource "aws_vpc" "carriyo-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name:  "${var.env_prefix}-vpc"
    }

  
}
resource "aws_subnet" "carriyo-subnet-1" {
    vpc_id = aws_vpc.carriyo-vpc.id
    cidr_block = var.subnet_crid_block
    availability_zone = var.avail_zone
    tags = {
        Name: "${var.env_prefix}-subnet-1"
    }
  
}

resource "aws_internet_gateway" "carriyo-igw" {
    vpc_id = aws_vpc.carriyo-vpc.id
    tags ={
      Name: "${var.env_prefix}-igw"
  }
  
}

resource "aws_route_table" "carriyo-route-table" {
    vpc_id = aws_vpc.carriyo-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.carriyo-igw.id

    }
  tags ={
      Name: "${var.env_prefix}-rtb"
  }
}
resource "aws_route_table_association" "a-rtb-subnet" {
    subnet_id =aws_subnet.carriyo-subnet-1.id
    route_table_id = aws_route_table.carriyo-route-table.id
  
}
resource "aws_security_group" "carriyo-sg" {
    name = "carriyo-sg"
    vpc_id =  aws_vpc.carriyo-vpc.id

    ingress {
    description = "SSH Access from outside"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 
  ingress {
    description = "SSH Access from outside"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  
  ingress {
    description = "SSH Access from outside"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
    tags = {
        Name: "${var.env_prefix}-sg"
    }
  
}*/
data "aws_ami" "latest-amazon-linux-image"{
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
    
}
/*output "aws_ami_id" {
    value = data.aws_ami.latest-amazon-linux-image.id
  
}
output "ec2_public_ip" {
  value = aws_instance.carriyo-server.id
}*/

/*resource "aws_key_pair" "ssh-key" {
    key_name = "carriyo-ec2-admin"
    public_key = ""
  
}*/

resource "aws_instance" "carriyo-server" {
    ami = data.aws_ami.latest-amazon-linux-image.id
    instance_type = var.instance_type

    subnet_id = aws_subnet.subnet-0496e362.id
    vpc_security_group_ids = [aws_security_group.vpc-228fb744.id]
    availability_zone = var.avail_zone

    associate_public_ip_address = true
    key_name = "carriyo-key"

    user_data = file("entry-script.sh")

    tags ={
        Name: "${var.env_prefix}-carriyo-server"
    }
  
}