output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.ecommerce-vpc.id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.ecommerce-vpc.cidr_block
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "public_subnet_cidrs" {
  description = "The CIDR blocks of the public subnets"
  value       = aws_subnet.public[*].cidr_block
}

output "private_subnet_cidrs" {
  description = "The CIDR blocks of the private subnets"
  value       = aws_subnet.private[*].cidr_block
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "nat_gateway_ids" {
  description = "The IDs of the NAT Gateway"
  value       = aws_nat_gateway.nat.id 
}

output "nat_gateway_ips" {
  description = "The public IPs of the NAT Gateways"
  value       =  aws_eip.nat.public_ip
}

output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.public.id
}

output "private_route_table_ids" {
  description = "The IDs of the private route tables"
  value       = aws_route_table.private[*].id
}

output "availability_zones" {
  description = "The availability zones used"
  value       = var.availability_zones
}
