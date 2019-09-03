## resource group creation for vnet
resource "azurerm_resource_group" "resource_group" {
    name        = "${var.resource_group}"
    location    = "${var.region}"
}

## vnet creation
resource "azurerm_virtual_network" "vnet" {
    name                = "${var.vnet_name}-vnet"
    address_space       = "${var.vnet_address_space}"
    location            = "${azurerm_resource_group.resource_group.location}"
    resource_group_name = "${azurerm_resource_group.resource_group.name}"
    depends_on          = [azurerm_resource_group.resource_group]
}

## Subnet creation
resource "azurerm_subnet" "subnet" {
    name                 = "${var.vnet_name}-subnet"
    resource_group_name  = "${azurerm_resource_group.resource_group.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    address_prefix       = "${var.vnet_address_space[0]}"
}

## Security Group creation
resource "azurerm_network_security_group" "sg" {
    name                = "${var.vnet_name}-sg"
    location            = "${azurerm_resource_group.resource_group.location}"
    resource_group_name = "${azurerm_resource_group.resource_group.name}"
}

## Associating subnet to security group
resource "azurerm_subnet_network_security_group_association" "sg-association" {
    subnet_id                   = "${azurerm_subnet.subnet.id}"
    network_security_group_id   = "${azurerm_network_security_group.sg.id}"
    depends_on                  = [azurerm_network_security_group.sg]
}

## Network Security Rule for ssh inbound port 22
resource "azurerm_network_security_rule" "ssh-in" {
    name                        = "ssh-inbound"
    priority                    = 100
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "22"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    resource_group_name         = "${azurerm_resource_group.resource_group.name}"
    network_security_group_name = "${azurerm_network_security_group.sg.name}"
}

## Network Security Rule for api-server inbound port 6443
resource "azurerm_network_security_rule" "https-inbound" {
    name                        = "https-inbound"
    priority                    = 101
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "6443"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    resource_group_name         = "${azurerm_resource_group.resource_group.name}"
    network_security_group_name = "${azurerm_network_security_group.sg.name}"
}