provider "aws" {

    region = "eu-west-1"

}
data "aws_vpc" "default" {
 default = true   
 }
 
 data "aws_subnet" "private" {
 vpc_id = data.aws_vpc.default.id
 filter {
   name = "tag:Name"  
     values = ["private-eu-west-1a"]    
   }   
   
   }

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


/*resource "aws_key_pair" "ssh-key" {
    key_name = "carriyo-ec2-admin"
    public_key = ""
  
}*/
data "aws_security_groups" "carriyo-sg" {
  
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
resource "aws_instance" "carriyo-server" {
    ami = data.aws_ami.latest-amazon-linux-image.id
    instance_type = var.instance_type

    subnet_id = data.aws_subnet.private.id
    vpc_security_group_ids = [data.aws_security_groups.carriyo-sg.id]
    availability_zone = var.avail_zone

    associate_public_ip_address = true
    key_name = "carriyo-key"

    user_data = file("entry-script.sh")

    tags ={
        Name: "${var.env_prefix}-carriyo-server"
    }
  
}