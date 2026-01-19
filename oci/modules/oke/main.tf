resource "oci_containerengine_cluster" "this" {
  compartment_id = var.compartment_id
  endpoint_config {
    is_public_ip_enabled = true
    subnet_id            = var.public_subnet_id
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
  }
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
      availability_domain = var.availability_domain
      subnet_id           = var.private_subnet_id
    }
    size    = 2
    nsg_ids = [var.worker_nsg_id]
  }
}
