variable "compartment_id" {}
variable "project_name" {}
variable "vcn_cidr" { default = "192.168.0.0/16" }
variable "api_subnet_cidr" { default = "192.168.0.0/30" }
variable "worker_subnet_cidr" { default = "192.168.1.0/24" }
variable "loadbalancer_subnet_cidr" { default = "192.168.2.0/24" }

