resource "oci_containerengine_cluster" "this" {
  compartment_id = var.compartment_id

  # Configuración del Endpoint Público
  endpoint_config {
    is_public_ip_enabled = true
    subnet_id            = var.api_subnet_id
  }

  freeform_tags = {
    "Project" = var.project_name
  }
  kubernetes_version = var.kubernetes_version
  name               = "${var.project_name}-cluster"
  vcn_id             = var.vcn_id

  options {
    add_ons {
      is_kubernetes_dashboard_enabled = false
      is_tiller_enabled               = false
    }
    admission_controller_options {
      is_pod_security_policy_enabled = false
    }
    # Aseguramos el uso de Flannel como CNI Plugin según tu plan
    kubernetes_network_config {
      pods_cidr     = "10.244.0.0/16"
      services_cidr = "10.96.0.0/16"
    }
  }
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

resource "oci_containerengine_node_pool" "this" {
  cluster_id         = oci_containerengine_cluster.this.id
  compartment_id     = var.compartment_id
  kubernetes_version = var.kubernetes_version
  name               = "managed-node-pool"

  node_shape = var.node_shape

  node_shape_config {
    memory_in_gbs = 16
    ocpus         = 1
  }

  node_source_details {
    image_id    = var.node_image_id
    source_type = "IMAGE"
  }

  node_config_details {
    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
      subnet_id           = var.worker_subnet_id # Cambiado para usar la subred de Workers
    }
    size = 2
    # Aplicamos el NSG que corregimos para permitir el tráfico de gestión (12250)
    # Si la variable es null, la lista de NSGs queda vacía [] y no da error
    nsg_ids = var.worker_nsg_id != null ? [var.worker_nsg_id] : []
  }
}

data "oci_containerengine_node_pool_option" "oke_options" {
  node_pool_option_id = "all"
}

