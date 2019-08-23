variable "azure_region" {
  description = "Region"
  default     = "westus"
}

variable "prod_az_state_backend" {
  description = "azure state backend"
  type        = "string"
  default     = "prodazstatebackend"
}

variable "resource_group" {
  description = "resource group"
  type        = "string"
  default     = "kthw"
}
