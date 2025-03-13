output "test_vpc_id" {
    value = aws_vpc.test_vpc.id
}

output "public_1_id" {
    value = aws_subnet.public_1.id
}

output "private_1_id" {
    value = aws_subnet.private_1.id
}

