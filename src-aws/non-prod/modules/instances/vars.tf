variable "ip_count" {
  description = "vm public IP count"
  type        = "string"
}

variable "count_index_private_ip" {
  description = "vm private IP count"
  type        = "list"
}
variable "key_name" {
  description = "SSH key name"
  type        = "string"
}

variable "user_data" {
  description = "Userdata to label and tag the nodes"
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
variable "worker_pod_cidrs" {
  type    = "list"
  default = []
}

variable "tag_suffix" {
  description = "suffix to differentiate master and node tags"
  type    = "string"
}

