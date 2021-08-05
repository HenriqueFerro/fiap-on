#Define OCI provider
provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

module "instance" {
  source                     = "oracle-terraform-modules/compute-instance/oci"
  instance_count             = 1 # how many instances do you want?
  ad_number                  = 1 # AD number to provision instances. If null, instances are provisionned in a rolling manner starting with AD1
  compartment_ocid           = var.compartment_ocid
  instance_display_name      = var.instance_display_name
  source_ocid                = var.source_ocid
  subnet_ocids               = var.subnet_ocids
  assign_public_ip           = var.assign_public_ip
  ssh_authorized_keys        = var.ssh_authorized_keys
  block_storage_sizes_in_gbs = var.block_storage_sizes_in_gbs
  shape                      = var.shape
  user_data                  = file("oci-user-data.sh")
}

/*# * This module will create a Flex Compute Instance, using default values: 1 OCPU, 16 GB memory.
# * `instance_flex_memory_in_gbs` and ìnstance_flex_ocpus` are not provided: default values will be applied.
module "instance_flex" {
  source = "oracle-terraform-modules/compute-instance/oci"
  # general oci parameters
  compartment_ocid = var.compartment_ocid
  #freeform_tags    = var.freeform_tags
  #defined_tags     = var.defined_tags
  # compute instance parameters
  ad_number             = var.instance_ad_number
  instance_count        = var.instance_count
  instance_display_name = var.instance_display_name
  shape                 = var.shape
  source_ocid           = var.source_ocid
  source_type           = var.source_type
  # operating system parameters
  ssh_authorized_keys = var.ssh_authorized_keys
  # networking parameters
  assign_public_ip = var.assign_public_ip
  subnet_ocids     = var.subnet_ocids
  # storage parameters
  block_storage_sizes_in_gbs = var.block_storage_sizes_in_gbs
}*/

output "instance_flex" {
  description = "ocid of created instances."
  value       = module.instance.instances_summary
}
