##=======================
## Variables passed to module from other modules
variable "zone" {
  description = "The zone to deploy the compute instance in"
  type        = string
}

variable "existing_ssh_key" {
  description = "The name of an existing SSH key to use for compute instances"
  type        = string
}

variable "name" {
  description = "The name to use for the compute instance"
  type        = string
}

variable "resource_group_id" {
  description = "The ID of the resource group to use for compute instances"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to use for compute instances"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC to use for compute instances"
  type        = string
}

variable "security_group_id" {
  description = "The ID of the security group to use for compute instances"
  type        = string
}

variable "tags" {
  description = "Tags to apply to compute instances"
  type        = list(string)
}

##=======================
## Variables with defaults

variable "instance_profile" {
  description = "The profile to use for compute instances"
  type        = string
  default     = "cx2-2x4"
}

variable "image_name" {
  description = "Name of the OS image to use for deployed compute hosts"
  type        = string
  default     = "ibm-ubuntu-22-04-3-minimal-amd64-1"
}

variable "allow_ip_spoofing" {
  description = "Whether to allow IP spoofing on the primary network interface"
  type        = bool
  default     = true
}