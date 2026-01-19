module "network" {
  source = "../../modules/vpc"

  project_name = "portfolio-aws"
  vpc_cidr     = "192.168.0.0/16"

  # Dos AZs para Alta Disponibilidad (High Availability)
  availability_zones = ["us-east-1a", "us-east-1b"]

  # Subredes Públicas (Para Load Balancers y Bastion Hosts)
  public_subnets = ["192.168.1.0/24", "192.168.2.0/24"]

  # Subredes Privadas (Para Nodos de EKS, App y DBs)
  private_subnets = ["192.168.10.0/24", "192.168.11.0/24"]
}


module "security" {
  source       = "../../modules/security"
  project_name = "portfolio-aws"
  vpc_id       = module.network.vpc_id # Encadenamiento de modulos
}
