resource "aws_instance" "bastion_host" {
    ami             = var.ami
    instance_type   = "t2.micro"
    key_name        = var.key_name
    subnet_id       = var.public_1_id
    security_groups = [var.bastion_host_sg_id]

    tags ={
        name = "bastion_host"
    }
}

resource "aws_instance" "private_instance" {
    ami             = var.ami
    instance_type   = "t2.micro"
    key_name        = var.key_name
    subnet_id       = var.private_1_id
    security_groups = [var.private_instance_sg_id]
    

    tags = {
        name = "private_instance"
    }
}