variable "compartment_id" { type = string }
variable "vcn_id" { type = string }
variable "project_name" { type = string }
variable "public_subnet_id" { type = string }
variable "private_subnet_id" { type = string }
variable "worker_nsg_id" { type = string }

variable "kubernetes_version" {
  default = "v1.31.1" # Versión estable actual en OCI
}

variable "node_shape" {
  default = "VM.Standard3.Flex"
}

# Variable específica para Chicago (us-chicago-1)
variable "node_image_id" {
  description = "OCID de la imagen Oracle Linux para OKE en Chicago"
  type        = string
  # Nota: Este OCID debe verificarse en tu consola de OCI según la versión de K8s
  default = "ocid1.image.oc1.us-chicago-1.aaaaaaaamuuhcl3qaf72ek7sgeum3b3oq34kkq4pogn6rfepw7rgqhl7ob2a"
}

variable "availability_domain" {
  description = "AD para Chicago (us-chicago-1-AD-1)"
  type        = string
  default     = "bDiT:US-CHICAGO-1-AD-1"
}
