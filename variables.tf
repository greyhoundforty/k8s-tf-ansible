variable "ibmcloud_api_key" {
  sensitive = true
}

variable "name" {
  default = "k8srt"
}

variable "region" {
  default = "us-south"
}

variable "vpc" {
  description = "Name of the VPC instance to use as a data source"
  type        = string
  default     = "k8srt-vpc"
}

variable "existing_resource_group" {}
variable "existing_ssh_key" {}
# variable "logging_key" {}
variable "loadbalancer_public_ip" {}

variable "service_cidr" {
  default = "10.96.0.0/16"
}

variable "cluster_cidr" {
  default = "172.18.0.0/16"
}

