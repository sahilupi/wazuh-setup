output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_cidr_block" {
  value = aws_vpc.vpc.cidr_block
}

output "vpc_name" {
  value = aws_vpc.vpc.arn
}

output "public_subnet" {
  value = aws_subnet.public_subnets.*.id
}
output "public_subnet_0" {
  value = aws_subnet.public_subnets.0.id
}

output "public_subnet_1" {
  value = aws_subnet.public_subnets.1.id
}

output "public_route_table" {
  value = aws_route_table.public.id
}
