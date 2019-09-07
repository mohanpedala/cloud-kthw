## Allocate public ip to loadbalancer
resource "azurerm_public_ip" "pubip" {
    name                = "${var.lb_name}-pubip"
    location            = "${var.region}"
    resource_group_name = "${var.resource_group_name}"
    allocation_method   = "Static"
}
