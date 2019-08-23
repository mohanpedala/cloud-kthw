output "properties"{
  value = "${azurerm_storage_account.az_storage_ac_backend.primary_access_key}"
}