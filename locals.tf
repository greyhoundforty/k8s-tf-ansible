locals {
  tags = [
    "owner:ryantiffany",
    "project:k8srt",
    "region:us-south"
  ]

  backup_tags = ["dailybackupenabled"]

  zones = length(data.ibm_is_zones.regional.zones)
  vpc_zones = {
    for zone in range(local.zones) : zone => {
      zone = "${var.region}-${zone + 1}"
    }
  }
  worker_sg_id  = data.ibm_is_vpc.vpc.security_group[0].group_id
  control_sg_id = data.ibm_is_vpc.vpc.security_group[1].group_id
  dmz_sg_id     = data.ibm_is_vpc.vpc.security_group[2].group_id

  #   securitygroup_name = [for sg in data.ibm_is_vpc.vpc.security_group : {
  #     name = sg.group_name,
  #     id   = sg.group_id
  #     }
  #   ]
}




