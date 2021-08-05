#AWS authentication variables
aws_access_key = "AKIATRRMJHDSN4VEGGNQ"
aws_secret_key = "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"
aws_region     = "sa-east-1"
aws_az         = "sa-east-1c"
aws_key_pair   = "henrique-ferro"

#OCI authentication variables
tenancy_ocid = "ocid1.tenancy.oc1..aaaaaaaa47bheytwsessxhugyxxybcjxn2mciwpph7t6bo3ruulncwkwfsiq"
user_ocid    = "ocid1.user.oc1..aaaaaaaa5ki2ncx3futq4ryqpka2fmswdnbd5ulu6gs5qc3hx366pvz7fcga"
fingerprint  = "a7:a0:07:3c:42:95:4e:8f:db:14:77:ce:1e:32:a9:e7"
region       = "sa-saopaulo-1"
private_key_path    = "/Users/henrique/Developer/oci/ssh-key/oracleidentitycloudservice_henrique.oci.teste-07-28-21-32.pem"
compartment_ocid    = "ocid1.compartment.oc1..aaaaaaaaz57gpr45knoo6aq4s6xy5ffwxoqprjuuzhvycb4xa57hrdj3nxea"

# Compute Instance Configurations
shape = "VM.Standard2.1"
instance_display_name = "sample_instance"
source_ocid         = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaajenaiawurtennq4liohi4vxsx7nbsx3txwswnt7io3fesnift5ha"
ssh_authorized_keys = "/Users/henrique/Developer/oci/ssh-key/ssh-key-linux-01.key.pub"
subnet_ocids        = ["ocid1.subnet.oc1.sa-saopaulo-1.aaaaaaaaezsc2kt4xswzw7y7eozrrkqjdr6iclqvghdxpliugxwursuhz5ra", "ocid1.subnet.oc1.sa-saopaulo-1.aaaaaaaamhcrnjzon2vbmximomq4coyltzpygb7dg7dyu3zyjplkuajmkmsq"]
assign_public_ip    = true