output "cluster_name" {
  description = "Nombre del clúster de EKS"
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "Endpoint para conectarse al API server de Kubernetes"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_ca_certificate" {
  description = "Certificado CA necesario para la autenticación"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}
