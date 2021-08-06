#Define OCI provider
provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

# Get a list of Availability Domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_ocid
}

# Create VCN vcn-teste
module "vcn" {
  source       = "oracle-terraform-modules/vcn/oci"
  version      = "2.3.0"

  # general oci parameters
  compartment_id = var.compartment_ocid
  region         = var.region

  # vcn parameters
  create_drg               = false         # boolean: true or false
  internet_gateway_enabled = true          # boolean: true or false
  lockdown_default_seclist = true          # boolean: true or false
  nat_gateway_enabled      = true          # boolean: true or false
  service_gateway_enabled  = true          # boolean: true or false
  vcn_cidr                 = "10.0.0.0/16" # VCN CIDR
  vcn_name                 = "${var.app_name}-${var.app_environment}-vcn"
  vcn_dns_label            = "${var.app_name}${var.app_environment}"
}

resource "oci_core_security_list" "webserver_security_list" {
  #Required
  compartment_id = var.compartment_ocid
  vcn_id         = module.vcn.vcn_id
  display_name   = "${var.app_name}-${var.app_environment}-security_list"

  egress_security_rules {
    stateless        = false
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }

  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    # Get protocol numbers from https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml ICMP is 1
    protocol = "1"
    # For ICMP type and code see: https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xhtml
    icmp_options {
      type = 3
      code = 4
    }
  }

  ingress_security_rules {
    stateless   = false
    source      = "10.0.0.0/16"
    source_type = "CIDR_BLOCK"
    # Get protocol numbers from https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml ICMP is 1
    protocol = "1"
    # For ICMP type and code see: https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xhtml
    icmp_options {
      type = 3
    }
  }

  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    # Get protocol numbers from https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml TCP is 6
    protocol = "6"
    tcp_options {
      min = 22
      max = 22
    }
  }

  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    # Get protocol numbers from https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml TCP is 6
    protocol = "6"
    tcp_options {
      min = 80
      max = 80
    }
  }
}

# Create Public Subnet
resource "oci_core_subnet" "public-subnet" {

  # Required
  compartment_id = var.compartment_ocid
  vcn_id         = module.vcn.vcn_id
  cidr_block     = "10.0.0.0/24"

  # Optional
  route_table_id    = module.vcn.ig_route_id
  security_list_ids = [oci_core_security_list.webserver_security_list.id]
  display_name      = "${var.app_name}-${var.app_environment}-public-subnet"
}

resource "oci_core_instance" "linux" {
  count               = 1
  compartment_id      = var.compartment_ocid
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  subnet_id           = oci_core_subnet.public-subnet.id
  display_name        = "${var.app_name}-${var.app_environment}-web-server"
  shape               = "VM.Standard.E2.1.Micro"

  source_details {
    source_id   = var.source_ocid
    source_type = "image"
  }

  metadata = {
    ssh_authorized_keys = var.ssh_authorized_keys
    user_data           = "${base64encode(file("./oci-user-data.sh"))}"
  }
}

output "oci-instance" {
  description = "ocid of created instances."
  value = {
    public_ip = oci_core_instance.linux[0].public_ip
  }
}
