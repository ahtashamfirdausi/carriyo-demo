output "aws_vpc_default_id"{
  value = data.aws_vpc.default.id
}
output "aws_subnet_carriya_private_id"{
  value = data.aws_subnet.private.id
}
output "carriyo_sg_id"{
    value =data.aws_security_groups.carriyo-sg.ids[0]
}