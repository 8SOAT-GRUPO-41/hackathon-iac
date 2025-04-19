output "internet_gateway_id" {
  value = aws_internet_gateway.this.id
}

output "internet_gateway_vpc_id" {
  value = aws_internet_gateway.this.vpc_id
}

output "internet_gateway_tags" {
  value = aws_internet_gateway.this.tags
}
