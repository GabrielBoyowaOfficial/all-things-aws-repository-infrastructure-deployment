




#---------------------------------------------------------------
# OUTPUT FILE FOR VPC MODULE
#---------------------------------------------------------------

output "provider_region" {
  value = var.provider_region
}

output "project_name" {
  value = var.project_name
}

output "vpc_flow_logs_bucket" {
  value = var.vpc_flow_logs_bucket
}

output "resource_tags" {
  value = var.resource_tags
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_1_id" {
  value = aws_subnet.public_subnet_1.id
}

output "public_subnet_2_id" {
  value = aws_subnet.public_subnet_2.id
}

output "private_subnet_1_id" {
  value = aws_subnet.private_subnet_1.id
}

output "private_subnet_2_id" {
  value = aws_subnet.private_subnet_2.id
}

output "DB_private_subnet_1_id" {
  value = aws_subnet.DB_private_subnet_1.id
}

output "DB_private_subnet_2_id" {
  value = aws_subnet.DB_private_subnet_2.id
}

output "internet_gateway" {
  value = aws_internet_gateway.internet_gateway
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat_gateway.id
}

output "nat_eip_public_ip" {
  value = aws_eip.nat_eip.public_ip
}
