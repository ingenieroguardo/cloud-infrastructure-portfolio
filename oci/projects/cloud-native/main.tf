module "network" {
  source         = "../../modules/vcn"
  compartment_id = var.compartment_id
  project_name   = "portfolio-cloud-native"
}

module "security" {
  source         = "../../modules/security"
  compartment_id = var.compartment_id
  vcn_id         = module.network.vcn_id
  project_name   = "portfolio-cloud-native"
}

module "oke" {
  source            = "../../modules/oke"
  compartment_id    = var.compartment_id
  vcn_id            = module.network.vcn_id
  project_name      = "portfolio-cloud-native"
  public_subnet_id  = module.network.public_subnet_id
  private_subnet_id = module.network.private_subnet_id
  worker_nsg_id     = module.security.worker_nsg_id
}
