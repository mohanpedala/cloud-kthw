variable "name" {
  description = "Name of the resources"
  type        = "string"
}

variable "k8s_tag" {
  description = "Tags for the resources"
  type        = "string"
}
variable "subnet_id" {
  description = "Subnet ID"
}

variable "vpc_id" {
  description = "VPC id"
}

variable "master_ips" {
  description = "List of Controller IP's"
  type    = "list"
}