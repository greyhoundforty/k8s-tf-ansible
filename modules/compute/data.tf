data "ibm_is_image" "base" {
  name = var.image_name
}

data "ibm_is_ssh_key" "sshkey" {
  name = var.existing_ssh_key
}

