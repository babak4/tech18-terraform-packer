variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "region" {}

variable "ssh_public_key" {}

variable cidrs {
    type = "map"
    default = {
        "vcn" = "10.0.0.0/16"
        "subnet_public" = "10.0.0.0/24"
        "subnet_private" = "10.1.2.0/24"
    }
}