variable "region" {
    description = "Region"
}

variable "vnet_name" {
    description = "vnet name"
}

variable "vnet_address_space" {
    type = "list"
}

variable "env" {
    description = "environment name"
    default {
        environment = "poc"
    }
}