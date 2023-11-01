module "resource_group" {
  source                       = "git::https://github.com/terraform-ibm-modules/terraform-ibm-resource-group.git?ref=v1.0.5"
  resource_group_name          = var.existing_resource_group == null ? "${var.name}-resource-group" : null
  existing_resource_group_name = var.existing_resource_group
}

module "bastion" {
  source            = "./modules/compute"
  name              = "${var.name}-bastion"
  resource_group_id = module.resource_group.resource_group_id
  vpc_id            = data.ibm_is_vpc.vpc.id
  subnet_id         = data.ibm_is_subnet.control_plane[0].id
  zone              = local.vpc_zones[0].zone
  security_group_id = local.dmz_sg_id
  existing_ssh_key  = var.existing_ssh_key
  tags              = local.tags
}

resource "ibm_is_floating_ip" "bastion" {
  name           = "${var.name}-bastion-ip"
  resource_group = module.resource_group.resource_group_id
  target         = module.bastion.primary_network_interface
  tags           = concat(local.tags, ["zone:${local.vpc_zones[0].zone}"])
}

# module "control-plane" {
#   source = "./modules/compute"
#   count = length(data.ibm_is_zones.regional.zones)

#   resource_group_id = module.resource_group.resource_group_id
#   vpc_id = data.ibm_is_vpc.vpc.id
#   subnet_id = data.ibm_is_subnet.control-plane[count.index].id
#   zone = local.vpc_zones[count.index].zone
#   tags = local.tags
#   security_group_id = local.control_sg_id
# }

module "control_plane" {
  count             = length(data.ibm_is_zones.regional.zones)
  source            = "./modules/compute"
  name              = "${var.name}-control-plane-${count.index}"
  resource_group_id = module.resource_group.resource_group_id
  vpc_id            = data.ibm_is_vpc.vpc.id
  subnet_id         = data.ibm_is_subnet.control_plane[count.index].id
  zone              = local.vpc_zones[count.index].zone
  security_group_id = local.control_sg_id
  existing_ssh_key  = var.existing_ssh_key
  tags              = local.tags
}

module "worker_plane" {
  count             = length(data.ibm_is_zones.regional.zones)
  source            = "./modules/compute"
  name              = "${var.name}-worker-plane-${count.index}"
  resource_group_id = module.resource_group.resource_group_id
  vpc_id            = data.ibm_is_vpc.vpc.id
  subnet_id         = data.ibm_is_subnet.worker_plane[count.index].id
  zone              = local.vpc_zones[count.index].zone
  security_group_id = local.worker_sg_id
  existing_ssh_key  = var.existing_ssh_key
  tags              = local.tags
}

module "ansible_inventory" {
  source                 = "./modules/ansible"
  bastion_public_ip      = ibm_is_floating_ip.bastion.address
  controllers            = module.control_plane.*.instance
  workers                = module.worker_plane.*.instance
  loadbalancer_fqdn      = "kubeapi.${var.name}.lab"
  loadbalancer_public_ip = var.loadbalancer_public_ip
}