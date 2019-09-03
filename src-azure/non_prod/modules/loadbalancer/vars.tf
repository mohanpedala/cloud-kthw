variable "resource_group_name" {
  description = "The name of the resource group the LB rule belongs to"
}

variable "lb_name" {
    description = "The name of the LB"
}

variable "protocol" {
  description = "The protocol which the rule applies to (Tcp/Udp)"
}

variable "frontend_port" {
  description = "The frontend port (ie. externally facing)"
}

variable "backend_port" {
  description = "The port on the backend services where the rule routes to"
}

variable "env" {
    description = "environment name"

    default = ["poc"]
}