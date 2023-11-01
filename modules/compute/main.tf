resource "ibm_is_instance" "compute" {
  name           = var.name
  vpc            = var.vpc_id
  image          = data.ibm_is_image.base.id
  profile        = var.instance_profile
  resource_group = var.resource_group_id

  metadata_service {
    enabled            = true
    protocol           = "https"
    response_hop_limit = 5
  }

  boot_volume {
    name = "${var.name}-vol"
  }

  primary_network_interface {
    subnet            = var.subnet_id
    allow_ip_spoofing = var.allow_ip_spoofing
    security_groups   = [var.security_group_id]
  }

  zone = var.zone
  keys = [data.ibm_is_ssh_key.sshkey.id]
  tags = concat(var.tags, ["zone:${var.zone}"])
}