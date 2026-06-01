variable "compartment_id" {}
variable "vcn_id" {}
variable "project_name" {}
variable "node_shape" {}
variable "node_image_id" {}
variable "availability_domain" {}
variable "worker_nsg_id" {
  description = "OCID del NSG (opcional)"
  type        = string
  default     = null # Esto permite que sea opcional
}
variable "kubernetes_version" {
  type    = string
  default = "v1.34.1"
}


# Cambia estos nombres exactos:
variable "api_subnet_id" {
  description = "ID de la subred /30 para el API Endpoint"
}

variable "worker_subnet_id" {
  description = "ID de la subred /24 para los Worker Nodes"
}

