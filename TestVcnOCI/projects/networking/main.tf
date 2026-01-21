# 1. Crear la VCN (Solo el contenedor)
module "network" {
  source                   = "../../modules/vcn"
  compartment_id           = var.compartment_id
  project_name             = var.project_name
  vcn_cidr                 = var.vcn_cidr
  api_subnet_cidr          = var.api_subnet_cidr
  worker_subnet_cidr       = var.worker_subnet_cidr
  loadbalancer_subnet_cidr = var.loadbalancer_subnet_cidr
}
