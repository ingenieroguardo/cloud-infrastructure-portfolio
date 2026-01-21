output "vcn_id" { value = oci_core_vcn.this.id }
output "api_subnet_id" { value = oci_core_subnet.api_subnet.id }
output "worker_subnet_id" { value = oci_core_subnet.worker_subnet.id }
output "loadbalancer_subnet_id" { value = oci_core_subnet.loadbalancer_subnet.id }
output "services_cidr" {
  description = "Bloque CIDR numérico de los servicios de Oracle"
  # Forzamos que devuelva el bloque de IPs
  value = data.oci_core_services.all_services.services[0].cidr_block
}
