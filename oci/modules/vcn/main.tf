resource "oci_core_vcn" "this" {
  cidr_block     = var.vcn_cidr
  compartment_id = var.compartment_id
  display_name   = "${var.project_name}-vcn"
  dns_label      = "portfoliovcn"
}

resource "oci_core_internet_gateway" "ig" {
  compartment_id = var.compartment_id
  display_name   = "${var.project_name}-igw"
  vcn_id         = oci_core_vcn.this.id
}

resource "oci_core_nat_gateway" "nat" {
  compartment_id = var.compartment_id
  display_name   = "${var.project_name}-nat-gw"
  vcn_id         = oci_core_vcn.this.id
}

# Subredes (Públicas para LB, Privadas para OKE)
resource "oci_core_subnet" "public" {
  cidr_block     = var.public_subnet_cidr
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.project_name}-pub-subnet"
  dns_label      = "pubsub"
}

resource "oci_core_subnet" "private" {
  cidr_block                 = var.private_subnet_cidr
  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.this.id
  display_name               = "${var.project_name}-priv-subnet"
  dns_label                  = "privsub"
  prohibit_public_ip_on_vnic = true
}
