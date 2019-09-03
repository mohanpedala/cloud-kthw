variable "env" {
    type = "string"
    default = "poc"
}

variable "master_count" {
  description = "The count of master nodes to create"
}

variable "master_ip_addresses" {
  description = "The list of private IP addresses for the master nodes"
  type        = "list"
}

variable "node_user" {
  description = "The initial user name for the provisioned instances"
}

variable "node_ssh_key" {
  description = "The public SSH key of the initial user for the provisioned instances"
}

variable "worker_ip_addresses" {
  description = "The list of private IP addresses for the worker nodes"
  type        = "list"
}

variable "worker_count" {
  description = "The count of worker nodes to create"
}