output "vpc_id" {
  description = "El ID de la VPC creada"
  value       = aws_vpc.this.id # Esto expone el ID del recurso
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}
