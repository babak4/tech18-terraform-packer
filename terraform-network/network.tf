resource "oci_core_vcn" "packernet_vcn" {
    compartment_id = "${var.compartment_ocid}"
    cidr_block = "${lookup(var.cidrs,  "vcn")}"
    display_name = "packernet-vcn"
    dns_label = "btg"
}

data "oci_identity_availability_domains" "packernet_ads" {
    compartment_id = "${var.compartment_ocid}"
}

resource "oci_core_subnet" "packernet_sn" {
    count = 2
    cidr_block = "10.0.${count.index}.0/24"
    display_name = "packernet-sn-0${count.index + 1}"
    dns_label = "packervcn0${count.index + 1}"
    compartment_id = "${var.compartment_ocid}"
    vcn_id = "${oci_core_vcn.packernet_vcn.id}"
    availability_domain = "${lookup(data.oci_identity_availability_domains.packernet_ads.availability_domains[count.index], "name")}"
    security_list_ids = ["${oci_core_security_list.packernet_sl.id}"]
    route_table_id = "${oci_core_route_table.packernet_rt.id}"
}

data "oci_core_subnets" "packernet_subnets" {
    #Required
    compartment_id = "${var.compartment_ocid}"
    vcn_id = "${oci_core_vcn.packernet_vcn.id}"
}

resource "oci_core_internet_gateway" "packernet_ig" {
    compartment_id = "${var.compartment_ocid}"
    vcn_id = "${oci_core_vcn.packernet_vcn.id}"
    display_name = "packernet-ig"
}

resource "oci_core_route_table" "packernet_rt"{
    compartment_id = "${var.compartment_ocid}"
    vcn_id = "${oci_core_vcn.packernet_vcn.id}"
    display_name = "packernet-rt"
    
    route_rules {
        destination = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"
        network_entity_id = "${oci_core_internet_gateway.packernet_ig.id}"
    }
}

resource "oci_core_security_list" "packernet_sl" {
  compartment_id = "${var.compartment_ocid}"
  display_name   = "packernet-SL"
  vcn_id         = "${oci_core_vcn.packernet_vcn.id}"

  egress_security_rules = [
    {
      protocol    = "all"
      destination = "0.0.0.0/0"
    },
  ]

  ingress_security_rules = [
    {
      protocol = "all"
      source   = "0.0.0.0/0"
    },
    {
      protocol = "6"
      source   = "0.0.0.0/0"

      tcp_options {
        "min" = 22
        "max" = 22
      }
    },
    {
      protocol = "6"
      source   = "0.0.0.0/0"

      tcp_options {
        "min" = 3000
        "max" = 3000
      }
    },
    {
        protocol = "1"
        source = "0.0.0.0/0"
    }
  ]
}

data "oci_core_security_lists" "packetnet_sls" {
    compartment_id = "${var.compartment_ocid}"
    vcn_id = "${oci_core_vcn.packernet_vcn.id}"
}