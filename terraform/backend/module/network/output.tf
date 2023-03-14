output "vpc_id" {
  value = aws_vpc.final_terraform.id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet[*].id
}
output "rds_subnet_id" {
  value = aws_subnet.rds_subnet[*].id
}
