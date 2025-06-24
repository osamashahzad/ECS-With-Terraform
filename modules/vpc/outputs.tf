output "nat_gateway_id" {
  value       = aws_nat_gateway.nat[*].id
  description = "The ID of the NAT Gateway"
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "lb_sg_id" {
  value = aws_security_group.loadbalancer-sg.id
}

output "ecs_sg_id" {
  value = aws_security_group.ecs-sg.id
}

# output "private_subnet_ids" {
#   value = aws_subnet.private.id[*]
# }
output "private_subnet_ids" {
  value = tolist(aws_subnet.private[*].id)
}
