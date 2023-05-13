output "route_table_arn" {
    description = "route table arn"
    value = aws_route_table.internet_route.arn
  
}

output "ig_arn" {
    description = "internet gateway arn"
    value = aws_internet_gateway.internet_gateway.arn
  
}