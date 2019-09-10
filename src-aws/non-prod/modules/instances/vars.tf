variable "key_name" {
  description = "SSH key name"
  type        = "string"
}

variable "vpc_security_group_ids" {
  description = "List of SG ID's"
  type    = "string"
}

variable "instance_type" {
  description = "Instance size"
}

variable "subnet_id" {
  description = "subnet id"
}

variable "master_ips" {
  description = "List of Master IP's"
  type    = "list"
}

variable "worker_ips" {
  description = "List of Worker IP's"
  type    = "list"
}
variable "worker_pod_cidrs" {
  type    = "list"
  default = []
}