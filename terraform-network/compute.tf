resource "oci_core_instance" "grafana_01" {
    count = 2
    availability_domain = "${lookup(data.oci_core_subnets.packernet_subnets.subnets[count.index], "availability_domain")}"
    compartment_id = "${var.compartment_ocid}"
    shape = "VM.Standard2.1"
    hostname_label = "grafana-0${count.index + 1}"

    create_vnic_details {
        subnet_id = "${lookup(data.oci_core_subnets.packernet_subnets.subnets[count.index],"id")}"
        display_name = "vnic_grafana_0${count.index + 1}"
    }
    display_name = "grafana_0${count.index + 1}"

    metadata {
        ssh_authorized_keys = "${var.ssh_public_key}"
    }
    source_details {

        #Required
        source_id = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaad6and265p2arogz6vo3fcd4tc7yufxauk7ch5a25nznc2mykrija"
        source_type = "image"
    }
}
output "public_ips" {
    value = "${oci_core_instance.grafana_01.*.public_ip}"
}