variable "compartment_id" {
  description = "OCID del compartment donde se crearán los recursos"
  type        = string
}

variable "project_name" {
  description = "Nombre del proyecto para prefijar los recursos"
  type        = string
  default     = "portfolio-oci"
}

variable "vcn_cidr" {
  description = "Rango CIDR para la VCN"
  type        = string
  default     = "192.168.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR para la subred pública (Load Balancers)"
  type        = string
  default     = "192.168.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR para la subred privada (Nodos OKE)"
  type        = string
  default     = "192.168.10.0/24"
}
