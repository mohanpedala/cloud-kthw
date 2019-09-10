variable "name" {
  description = "Tags for the resources"
  type        = "string"
}

variable "k8s_tag" {
  description = "Tags for the resources"
  type        = "string"
}

variable "cidr_range" {
  description = "CIDR range for the instances"
  type        = "string"
}