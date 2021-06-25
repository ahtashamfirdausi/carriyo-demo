provider "aws" {
 region = "eu-west-1"
}
data "aws_vpc" "default" {
 default = true   
 }
 data "aws_subnet" "public" {
 vpc_id = data.aws_vpc.default.id
 filter {
   name = "tag:Name"  
     values = ["public-eu-west-1a"]    
   }   
   }
data "aws_security_groups" "carriyo-sg" {
  filter {
    name   = "group-name"
    values = ["default"]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
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
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAmYObUZLxh7dlCS/SpZB+e4F6+BqWpyAWjNwucjl1Pm7VN5ehpAjmrbnoXnmWK93B0o2FnuZlFfOADYW032t363xJgTD+QPu25lW6KEHxGr1Pu1QbGz5DzLTx95rByCIEOU3GVIcbCLYoqBJce7CqwgA2PRjBbvVW8u/tlfth7kEg+ZmZ4zQfE6BX5hcPpRGPZxJcFLgeJM5f4rLuxS4zVmNPRFEnn9YQET8vKaKFuWtrV/XxAKggDVEyxfQtS5Tlub7uYpgFtm9pRIZ3HOhd8JjyBhPFH73ROHsp1N9DVKOsqEPhCM3Ml+Djgn4i+EWTgSI/a7PJDbpPAgJPcgWZKQ== rsa-key-20210622"
}*/
resource "aws_instance" "carriyo-server" {
    ami = data.aws_ami.latest-amazon-linux-image.id
    instance_type = var.instance_type
    subnet_id = data.aws_subnet.public.id
    vpc_security_group_ids = [data.aws_security_groups.carriyo-sg.ids[0]]
    availability_zone = var.avail_zone
    associate_public_ip_address = true
 // key_name = aws_key_pair.ssh-key.id
    key_name = "carriyo-key"
    user_data = file("entry-script.sh")
    tags ={
        Name: "${var.env_prefix}-Magento"
    }
}