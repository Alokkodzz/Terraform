resource "aws_instance" "TF_test" {
    ami = var.ami
    instance_type = var.instance_type
    subnet_id = element(aws_subnet.TF_subnet_public[*].id, 0)
    vpc_security_group_ids = [aws_security_group.TF_SG.id]
    tags = var.tags
    associate_public_ip_address = true
  
}