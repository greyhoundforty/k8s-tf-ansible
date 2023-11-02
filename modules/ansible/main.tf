resource "local_file" "ansible-inventory" {
  content = templatefile("${path.module}/templates/inventory.tmpl",
    {
      bastion_ip  = var.bastion_public_ip
      controllers = var.controllers
      workers     = var.workers
    }
  )
  filename = "${path.module}/inventory.ini"
}

resource "local_file" "ansible-vars" {
  content = templatefile("${path.module}/templates/vars.tmpl",
    {
      loadbalancer_fqdn      = var.loadbalancer_fqdn
      loadbalancer_public_ip = var.loadbalancer_public_ip
      cluster_cidr           = var.cluster_cidr
      service_cidr = var.service_cidr
    }
  )
  filename = "${path.module}/playbooks/vars/cluster-vars.yml"
}