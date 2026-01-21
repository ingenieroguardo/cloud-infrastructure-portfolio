module "network" {
  source                   = "../../modules/vcn"
  compartment_id           = var.compartment_id
  project_name             = var.project_name
  vcn_cidr                 = var.vcn_cidr
  api_subnet_cidr          = var.api_subnet_cidr
  worker_subnet_cidr       = var.worker_subnet_cidr
  loadbalancer_subnet_cidr = var.loadbalancer_subnet_cidr
}

# oci/projects/cloud-native/main.tf

module "oke" {
  source              = "../../modules/oke"
  compartment_id      = var.compartment_id
  vcn_id              = module.network.vcn_id
  api_subnet_id       = module.network.api_subnet_id
  worker_subnet_id    = module.network.worker_subnet_id
  kubernetes_version  = "v1.34.1"
  node_shape          = "VM.Standard3.Flex"
  node_image_id       = var.node_image_id
  availability_domain = var.availability_domain
  project_name        = var.project_name
}
