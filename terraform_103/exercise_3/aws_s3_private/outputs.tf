output "private_subnet_ranges" {
  value = aws_subnet.private[*].cidr_block
}

output "public_subnet_ranges" {
  value = aws_subnet.public[*].cidr_block
}