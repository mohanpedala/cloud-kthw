resource "azurerm_network_interface" "nic" {
  name                = "${var.vm_prefix}-${count.index}-nic"
  location            = "${var.region}"
  resource_group_name = "${var.resource_group_name}"

  count = "${var.vm_count}"

  enable_ip_forwarding = true

  internal_dns_name_label = "${var.vm_prefix}-${count.index}"

  ip_configuration {
    name                          = "${var.vm_prefix}-${count.index}-ip-config"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "${element(var.private_ip_addresses, count.index) != "" ? "static" : "dynamic"}"
    private_ip_address            = "${element(var.private_ip_addresses, count.index)}"
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "test" {
  count                   = "${var.vm_count}"
  network_interface_id    = "${azurerm_network_interface.nic.*.id[count.index]}"
  ip_configuration_name   = "${var.vm_prefix}-${count.index}-ip-config"
  backend_address_pool_id = "${var.lb_backend_pool != "" ? var.lb_backend_pool : ""}"
}

resource "azurerm_availability_set" "as" {
  name                = "${var.vm_prefix}-as"
  location            = "${var.region}"
  resource_group_name = "${var.resource_group_name}"

  managed = true

#   tags = "${var.tags}"
}

resource "azurerm_virtual_machine" "vm" {
  name                  = "${var.vm_prefix}-${count.index}"
  location              = "${var.region}"
  resource_group_name   = "${var.resource_group_name}"
  network_interface_ids = ["${azurerm_network_interface.nic.*.id[count.index]}"]
  vm_size               = "${var.vm_size}"

  count = "${var.vm_count}"

  availability_set_id = "${azurerm_availability_set.as.id}"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.vm_prefix}-${count.index}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = 50
  }

  os_profile {
    computer_name  = "${var.vm_prefix}-${count.index}"
    admin_username = "${var.username}"
  }
  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.username}/.ssh/authorized_keys"
      key_data = "${var.ssh_key}"
    }
  }
#   tags = "${var.tags}"
}
