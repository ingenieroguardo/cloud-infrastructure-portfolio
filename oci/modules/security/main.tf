# NSG para el Load Balancer
resource "oci_core_network_security_group" "lb_nsg" {
  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id
  display_name   = "${var.project_name}-lb-nsg"
}

# Regla HTTP para el LB
resource "oci_core_network_security_group_security_rule" "lb_ingress_http" {
  network_security_group_id = oci_core_network_security_group.lb_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      min = 80
      max = 80
    }
  }
}

# NSG para los Worker Nodes (OKE)
resource "oci_core_network_security_group" "worker_nsg" {
  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id
  display_name   = "${var.project_name}-worker-nsg"
}

# Regla: Solo permitir tráfico desde el NSG del Load Balancer
resource "oci_core_network_security_group_security_rule" "worker_ingress_from_lb" {
  network_security_group_id = oci_core_network_security_group.worker_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  source                    = oci_core_network_security_group.lb_nsg.id
  source_type               = "NETWORK_SECURITY_GROUP"
  tcp_options {
    destination_port_range {
      min = 80
      max = 80
    }
  }
}

# Permitir todo el tráfico de salida (Egress)
resource "oci_core_network_security_group_security_rule" "all_egress" {
  network_security_group_id = oci_core_network_security_group.worker_nsg.id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
}
