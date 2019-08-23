terraform {
  backend "azurerm" {
    storage_account_name  = "${var.prod_az_state_backend}"
    container_name        = "prod_az_state_lock"
    key                   = "azure_terraform.tfstate"
    access_key            = "<access_key>"
  }
}