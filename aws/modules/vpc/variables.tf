variable "vpc_cidr" {
  description = "CIDR block para la VPC"
  type        = string
}

variable "project_name" {
  description = "Nombre del proyecto para etiquetas"
  type        = string
}

variable "public_subnets" {
  description = "Lista de CIDRs para subredes públicas"
  type        = list(string)
}

variable "private_subnets" {
  description = "Lista de CIDRs para subredes privadas"
  type        = list(string)
}

variable "availability_zones" {
  description = "Lista de AZs a usar"
  type        = list(string)
}
