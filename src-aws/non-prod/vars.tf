variable "k8s_tag" {
  description = "Tags for the resources"
  type        = "string"
}

variable "cidr_range" {
  description = "CIDR range for the instances"
  type    = "string"
}

variable "master_ips" {
  type    = "list"
  default = []
}

variable "worker_ips" {
  type    = "list"
  default = []
}

variable "worker_pod_cidrs" {
  type    = "list"
  default = []
}

## SSH Key name to map
variable "key_name" {
  description = "ssh key name"
  type        = "string"
}

variable "node_user" {
  description = "node username"
  type        = "string"
}

variable "worker_count" {
  description = "The count of worker nodes to create"
}