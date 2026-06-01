resource "oci_core_vcn" "this" {
  cidr_block     = var.vcn_cidr
  compartment_id = var.compartment_id
  display_name   = "vcn-cloud-portfolio"
  dns_label      = "okevcn"
}

# Gateways
resource "oci_core_internet_gateway" "ig" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "internet-gateway-cloud-portfolio"
}

resource "oci_core_nat_gateway" "nat" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "nat-gateway-cloud-portfolio"
}

resource "oci_core_service_gateway" "sg" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "service-gateway-cloud-portfolio"
  services { service_id = data.oci_core_services.all_services.services[0].id }
}

/*data "oci_core_services" "all_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}
*/

# =============================================================================
# Tablas de rutas
# =============================================================================

# Tabla de rutas para la subred de la API (Pública)
resource "oci_core_route_table" "api_rt" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "routetable-KubernetesAPIendpoint"

  route_rules {
    network_entity_id = oci_core_internet_gateway.ig.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}

# 1. Ajusta el Data Source (Chicago usa nombres específicos)
data "oci_core_services" "all_services" {
  filter {
    name   = "name"
    values = [".*Services.*"] # Filtro más permisivo
    regex  = true
  }
}

resource "oci_core_route_table" "worker_rt" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "routetable-workernodes"


  route_rules {
    network_entity_id = oci_core_nat_gateway.nat.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}

resource "oci_core_route_table_attachment" "worker_rt_attachment" {
  subnet_id      = oci_core_subnet.worker_subnet.id
  route_table_id = oci_core_route_table.worker_rt.id
}



# Tabla de rutas para los Load Balancers (Pública)
resource "oci_core_route_table" "lb_rt" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "routetable-serviceloadbalancers"

  route_rules {
    network_entity_id = oci_core_internet_gateway.ig.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}

# =============================================================================
# Lista de Seguridad para el API Endpoint (Público)
# =============================================================================
resource "oci_core_security_list" "api_endpoint_seclist" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "seclist-KubernetesAPIendpoint"

  # --- REGLAS DE ENTRADA (INGRESS) ---

  # 1. Comunicación desde los Workers al API (6443)
  ingress_security_rules {
    protocol    = "6" # TCP
    source      = "192.168.1.0/24"
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      min = 6443
      max = 6443
    }
    description = "Comunicación del nodo de trabajador al punto final de API."
  }

  # 2. Comunicación desde los Workers al Plano de Control (12250)
  ingress_security_rules {
    protocol    = "6" # TCP
    source      = "192.168.1.0/24"
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      min = 12250
      max = 12250
    }
    description = "Comunicación del nodo de trabajador al plano de control."
  }

  # 3. ICMP para Detección de Ruta (MTU)
  ingress_security_rules {
    protocol    = "1" # ICMP
    source      = "192.168.1.0/24"
    source_type = "CIDR_BLOCK"
    stateless   = false
    icmp_options {
      type = 3
      code = 4
    }
    description = "Detección de ruta desde los trabajadores."
  }

  # 4. Acceso externo al API (Opcional - Internet)
  ingress_security_rules {
    protocol    = "6" # TCP
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      min = 6443
      max = 6443
    }
    description = "Acceso externo al punto final de API de Kubernetes."
  }

  # --- REGLAS DE SALIDA (EGRESS) ---

  # 1. Salida hacia Oracle Services Network (TCP TODOS)
  egress_security_rules {
    protocol         = "6" # TCP
    destination      = "all-ord-services-in-oracle-services-network"
    destination_type = "SERVICE_CIDR_BLOCK"
    stateless        = false
    description      = "Permitir que el plano de control se comunique con OKE."
  }

  # 2. Salida hacia Oracle Services Network (ICMP 3,4)
  egress_security_rules {
    protocol         = "1" # ICMP
    destination      = "all-ord-services-in-oracle-services-network"
    destination_type = "SERVICE_CIDR_BLOCK"
    stateless        = false
    icmp_options {
      type = 3
      code = 4
    }
    description = "Detección de ruta hacia servicios de Oracle."
  }

  # 3. Comunicación hacia los Workers (TCP TODOS)
  egress_security_rules {
    protocol         = "6" # TCP
    destination      = "192.168.1.0/24"
    destination_type = "CIDR_BLOCK"
    stateless        = false
    description      = "Permitir que el plano de control se comunique con nodos de trabajador."
  }

  # 4. Comunicación hacia los Workers (ICMP 3,4)
  egress_security_rules {
    protocol         = "1" # ICMP
    destination      = "192.168.1.0/24"
    destination_type = "CIDR_BLOCK"
    stateless        = false
    icmp_options {
      type = 3
      code = 4
    }
    description = "Detección de ruta hacia nodos de trabajador."
  }
}

# =============================================================================
# Lista de Seguridad para los Worker Nodes (Privada)
# =============================================================================
resource "oci_core_security_list" "worker_nodes_seclist" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "seclist-workernodes"

  # --- REGLAS DE ENTRADA (INGRESS) ---

  # 1. Comunicación interna entre Pods (Todo el tráfico entre nodos trabajadores)
  ingress_security_rules {
    protocol    = "all"
    source      = "192.168.1.0/24"
    source_type = "CIDR_BLOCK"
    stateless   = false
    description = "Permitir comunicación interna entre pods en nodos trabajadores."
  }

  # 2. Comunicación desde el API Endpoint hacia los Workers (TCP TODOS)
  ingress_security_rules {
    protocol    = "6" # TCP
    source      = "192.168.0.0/30"
    source_type = "CIDR_BLOCK"
    stateless   = false
    description = "Permitir que el plano de control se comunique con los nodos de trabajador."
  }

  # 3. ICMP para Detección de Ruta (MTU)
  ingress_security_rules {
    protocol    = "1" # ICMP
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false
    icmp_options {
      type = 3
      code = 4
    }
    description = "Detección de ruta desde cualquier origen."
  }

  # 4. SSH (Opcional - Desde la subred de Load Balancers o Bastion)
  ingress_security_rules {
    protocol    = "6"              # TCP
    source      = "192.168.2.0/24" # Usando tu CIDR de Load Balancer como origen
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      min = 22
      max = 22
    }
    description = "Acceso SSH entrante a nodos gestionados."
  }

  # 5. Tráfico desde el Load Balancer a NodePorts (30000-32767)
  ingress_security_rules {
    protocol    = "6" # TCP
    source      = "192.168.2.0/24"
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      min = 30000
      max = 32767
    }
    description = "Tráfico del equilibrador de carga a los puertos de nodo (NodePorts)."
  }

  # 6. Health Checks (Kube-proxy) desde el Load Balancer
  ingress_security_rules {
    protocol    = "6" # TCP
    source      = "192.168.2.0/24"
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      min = 10256
      max = 10256
    }
    description = "Comunicación del equilibrador de carga con kube-proxy."
  }

  # --- REGLAS DE SALIDA (EGRESS) ---

  # 1. Comunicación interna entre Pods
  egress_security_rules {
    protocol         = "all"
    destination      = "192.168.1.0/24"
    destination_type = "CIDR_BLOCK"
    stateless        = false
    description      = "Permitir comunicación interna entre pods en nodos trabajadores."
  }

  # 2. ICMP para Detección de Ruta
  egress_security_rules {
    protocol         = "1" # ICMP
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    stateless        = false
    icmp_options {
      type = 3
      code = 4
    }
    description = "Detección de ruta hacia internet/VCN."
  }

  # 3. Salida hacia Oracle Services Network (Chicago)
  egress_security_rules {
    protocol         = "6" # TCP
    destination      = "all-ord-services-in-oracle-services-network"
    destination_type = "SERVICE_CIDR_BLOCK"
    stateless        = false
    description      = "Comunicación de nodos trabajadores con el servicio de OKE."
  }

  # 4. Salida hacia el API Endpoint (6443)
  egress_security_rules {
    protocol         = "6" # TCP
    destination      = "192.168.0.0/30"
    destination_type = "CIDR_BLOCK"
    stateless        = false
    tcp_options {
      min = 6443
      max = 6443
    }
    description = "Comunicación del trabajador al punto final de API."
  }

  # 5. Salida hacia el Plano de Control (12250)
  egress_security_rules {
    protocol         = "6" # TCP
    destination      = "192.168.0.0/30"
    destination_type = "CIDR_BLOCK"
    stateless        = false
    tcp_options {
      min = 12250
      max = 12250
    }
    description = "Comunicación del trabajador al plano de control (gestión)."
  }

  # 6. Salida general a Internet (Para descargar imágenes y parches)
  egress_security_rules {
    protocol         = "6" # TCP
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    stateless        = false
    description      = "Permitir que los nodos trabajadores se comuniquen con Internet (vía NAT)."
  }
}


# =============================================================================
# Lista de Seguridad para los Equilibradores de Carga (Pública)
# =============================================================================
resource "oci_core_security_list" "loadbalancer_seclist" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "seclist-loadbalancers"

  # --- REGLAS DE ENTRADA (INGRESS) ---

  # 1. Tráfico HTTP (Puerto 80) desde Internet
  ingress_security_rules {
    protocol    = "6" # TCP
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      min = 80
      max = 80
    }
    description = "Tráfico HTTP de entrada desde Internet."
  }

  # 2. Tráfico HTTPS (Puerto 443) desde Internet
  ingress_security_rules {
    protocol    = "6" # TCP
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      min = 443
      max = 443
    }
    description = "Tráfico HTTPS de entrada desde Internet."
  }

  # 3. Tráfico Puerto Alternativo (8080) desde Internet
  ingress_security_rules {
    protocol    = "6" # TCP
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      min = 8080
      max = 8080
    }
    description = "Tráfico de entrada en puerto 8080 (servicios específicos)."
  }

  # --- REGLAS DE SALIDA (EGRESS) ---

  # 1. Tráfico hacia los Workers en el rango de NodePorts (30000-32767)
  egress_security_rules {
    protocol         = "6" # TCP
    destination      = "192.168.1.0/24"
    destination_type = "CIDR_BLOCK"
    stateless        = false
    tcp_options {
      min = 30000
      max = 32767
    }
    description = "Salida del equilibrador de carga hacia NodePorts de los trabajadores."
  }

  # 2. Health Checks hacia kube-proxy en los Workers (10256)
  egress_security_rules {
    protocol         = "6" # TCP
    destination      = "192.168.1.0/24"
    destination_type = "CIDR_BLOCK"
    stateless        = false
    tcp_options {
      min = 10256
      max = 10256
    }
    description = "Salida para comprobación de estado hacia kube-proxy."
  }
}




# Subredes 
# Subred de API
resource "oci_core_subnet" "api_subnet" {
  cidr_block     = var.api_subnet_cidr
  vcn_id         = oci_core_vcn.this.id
  compartment_id = var.compartment_id
  display_name   = "KubernetesAPIendpoint"
  # Referencia local:
  security_list_ids = [oci_core_security_list.api_endpoint_seclist.id]
  route_table_id    = oci_core_route_table.api_rt.id
}

# Subred de Workers
resource "oci_core_subnet" "worker_subnet" {
  cidr_block                 = var.worker_subnet_cidr
  vcn_id                     = oci_core_vcn.this.id
  compartment_id             = var.compartment_id
  display_name               = "workernodes"
  prohibit_public_ip_on_vnic = true
  # Referencia local:
  security_list_ids = [oci_core_security_list.worker_nodes_seclist.id]
  route_table_id    = oci_core_route_table.worker_rt.id
}

# Subred de Load Balancer
resource "oci_core_subnet" "loadbalancer_subnet" {
  cidr_block     = var.loadbalancer_subnet_cidr
  vcn_id         = oci_core_vcn.this.id
  compartment_id = var.compartment_id
  display_name   = "loadbalancer"
  # Referencia local:
  security_list_ids = [oci_core_security_list.loadbalancer_seclist.id]
  route_table_id    = oci_core_route_table.lb_rt.id
}
