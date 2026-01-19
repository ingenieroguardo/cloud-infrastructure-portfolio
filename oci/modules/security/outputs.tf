output "lb_nsg_id" { value = oci_core_network_security_group.lb_nsg.id }
output "worker_nsg_id" { value = oci_core_network_security_group.worker_nsg.id }
