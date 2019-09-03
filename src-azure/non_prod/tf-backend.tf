terraform {
  backend "azurerm" {
    storage_account_name  = "prodazstatebackend"
    container_name        = "prodazstatelock"
    key                   = "prod.terraform.tfstate"
    access_key            = "<Enter prodazstatebacked property from the bootstrap output>"
  }
}