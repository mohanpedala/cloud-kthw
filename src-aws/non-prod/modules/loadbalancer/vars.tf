variable "name" {
  description = "Tags for the resources"
  type        = "string"
}
variable "subnet_id" {
  description = "The name of the resource group the LB rule belongs to"
}

variable "vpc_id" {
  description = "The name of the resource group the LB rule belongs to"
}

variable "controller_ips" {
  type    = "list"
  default = ["10.240.0.10", "10.240.0.11", "10.240.0.12"]
}