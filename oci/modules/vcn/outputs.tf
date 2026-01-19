output "vcn_id" {
  description = "ID de la VCN creada"
  value       = oci_core_vcn.this.id
}

output "public_subnet_id" {
  description = "ID de la subred pública"
  value       = oci_core_subnet.public.id
}

output "private_subnet_id" {
  description = "ID de la subred privada"
  value       = oci_core_subnet.private.id
}

output "default_security_list_id" {
  description = "ID de la lista de seguridad por defecto de la VCN"
  value       = oci_core_vcn.this.default_security_list_id
}
