data "ibm_is_zones" "regional" {
  region = var.region
}

data "ibm_is_vpc" "vpc" {
  name = var.vpc
}

data "ibm_is_subnet" "control_plane" {
  count = length(data.ibm_is_zones.regional.zones)
  name  = "k8srt-frontend-subnet-z${count.index + 1}"
}

data "ibm_is_subnet" "worker_plane" {
  count = length(data.ibm_is_zones.regional.zones)
  name  = "k8srt-backend-subnet-z${count.index + 1}"
}




