output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public_subnet.*.id
}

output "app_subnet_id" {
  description = "The ID of the app subnet"
  value       = aws_subnet.app_subnet.*.id
}

output "db_subnet_id" {
  description = "The ID of the db subnet"
  value       = aws_subnet.db_subnet.*.id
}

output "route_table_id" {
  description = "The ID of the public subnet"
  value       = aws_route_table.public[*]
}

output "az" {
  description = "The az"
  value       = data.aws_availability_zones.available
}