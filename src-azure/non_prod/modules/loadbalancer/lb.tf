## Create load balancer
resource "azurerm_lb" "lb" {
    name                = "${var.resource_group_name}-${var.lb_name}"
    location            = "${var.region}"
    resource_group_name = "${var.resource_group_name}"

    frontend_ip_configuration {
        name                 = "PublicIPAddress"
        public_ip_address_id = "${azurerm_public_ip.pubip.id}"
    }
}

## Create load balancer backend address pool
resource "azurerm_lb_backend_address_pool" "lbpool" {
    resource_group_name = "${var.resource_group_name}"
    loadbalancer_id     = "${azurerm_lb.lb.id}"
    name                = "${azurerm_lb.lb.name}-BackEndAddressPoolcke"
}

## LoadBalancer Rule
## Create lb probe
resource "azurerm_lb_probe" "probe" {
    resource_group_name = "${var.resource_group_name}"
    loadbalancer_id     = "${azurerm_lb.lb.id}"
    name                = "${azurerm_lb.lb.name}_probe"
    port                = "${var.backend_port}"
}

## Create lb rule for ssh
resource "azurerm_lb_rule" "ssh" {
    resource_group_name            = "${var.resource_group_name}"
    loadbalancer_id                = "${azurerm_lb.lb.id}"
    name                           = "${azurerm_lb.lb.name}_LBRule"
    protocol                       = "${var.protocol}"
    frontend_port                  = "${var.frontend_port}"
    backend_port                   = "${var.backend_port}"
    frontend_ip_configuration_name = "${azurerm_lb.lb.frontend_ip_configuration[0].name}"
    backend_address_pool_id        = "${azurerm_lb_backend_address_pool.lbpool.id}"
    probe_id                       = "${azurerm_lb_probe.probe.id}"
}
