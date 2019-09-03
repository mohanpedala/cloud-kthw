
variable "vm_prefix" {
  description = "The prefix for VM names"
}

variable "vm_count" {
  description = "The count of VMs to create"
}

variable "vm_size" {
  description = "VM instance size"
}

variable "lb_backend_pool" {
  default     = ""
  description = "LB backend pool to attach the VM NICs to"
}

variable "subnet_id" {
  description = "The subnet ID to place the VM NICs into"
}

variable "resource_group_name" {}

variable "ssh_key" {
  description = "The public SSH key to provision to the instance user"
}

variable "private_ip_addresses" {
  type        = "list"
  description = "A list of private IP addresses that are attached in that order to the VM NICs"
}

variable "username" {}
