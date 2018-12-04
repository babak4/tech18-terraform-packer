output "subnet_id" {
    value = "${oci_core_subnet.packernet_sn.*.id}"
}
