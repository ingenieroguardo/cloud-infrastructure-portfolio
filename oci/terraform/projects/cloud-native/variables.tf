variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" { default = "us-chicago-1" }
variable "compartment_id" {}
variable "project_name" { default = "portfolio-cloud-native" }
variable "availability_domain" { default = "mIdS:ORD-AD-1" }
variable "node_image_id" { default = "ocid1.image.oc1.us-chicago-1.aaaaaaaa6pnm4gnyz2psmbt6qgnf24un5f566vvew25bueer2b3bng42q3ba" }
variable "vcn_cidr" { default = "192.168.0.0/16" }
variable "api_subnet_cidr" { default = "192.168.0.0/30" }
variable "worker_subnet_cidr" { default = "192.168.1.0/24" }
variable "loadbalancer_subnet_cidr" { default = "192.168.2.0/24" }
