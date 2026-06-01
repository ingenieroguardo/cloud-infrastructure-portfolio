variable "project_name" {
  description = "Nombre base para los recursos del proyecto"
  type        = string
  default     = "portfolio-aws"
}

variable "vpc_cidr" {
  description = "Bloque CIDR para la VPC"
  type        = string
  default     = "192.168.0.0/16"
}

variable "availability_zones" {
  description = "Lista de zonas de disponibilidad para el despliegue"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets" {
  description = "CIDRs para las subredes públicas"
  type        = list(string)
  default     = ["192.168.1.0/24", "192.168.2.0/24"]
}

variable "private_subnets" {
  description = "CIDRs para las subredes privadas"
  type        = list(string)
  default     = ["192.168.10.0/24", "192.168.11.0/24"]
}
