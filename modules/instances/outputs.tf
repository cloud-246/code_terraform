output "bastion_host_id" {
    value = aws_instance.bastion_host.id
}

output "private_instance_id" {
    value = aws_instance.private_instance.id
}