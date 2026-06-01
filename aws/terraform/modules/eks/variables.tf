variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "app_sg_id" {
  description = "Security group de la aplicación para permitir acceso al clúster"
  type        = string
}
