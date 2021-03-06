resource "azurerm_resource_group" "resource_group" {
  name      = "${var.backend_resource_group}"
  location  = "${var.region}"
#   lifecycle {
#     prevent_destroy = true
#   }
}
resource "azurerm_storage_account" "az_storage_ac_backend" {
  name                     = "${var.prod_az_state_backend}"
  resource_group_name      = "${var.backend_resource_group}"
  location                 = "${var.region}"
  account_tier             = "standard"
  account_replication_type = "LRS"
  depends_on               = [azurerm_resource_group.resource_group]
#   lifecycle {
#     prevent_destroy = true
#   }
}
resource "azurerm_storage_container" "prodazstatelock" {
  name                  = "prodazstatelock"
  resource_group_name   = "${var.backend_resource_group}"
  storage_account_name  = "${azurerm_storage_account.az_storage_ac_backend.name}"
  container_access_type = "private"
  depends_on            = [azurerm_storage_account.az_storage_ac_backend]
#   lifecycle {
#     prevent_destroy = true
#   }
}