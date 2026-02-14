output "azs" {
  value = local.az_names

}
output "public_subnet_id_1a" {
  value = aws_subnet.public

}
output "vpc_id" {
  value = aws_vpc.main.id
}
output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}
output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}
output "database_subnet_ids" {
  value = aws_subnet.database[*].id
}

output "database_subnet_group_id" {
  value = aws_db_subnet_group.default.id
}

output "database_subnet_group_name" {
  value = aws_db_subnet_group.default.name
}
