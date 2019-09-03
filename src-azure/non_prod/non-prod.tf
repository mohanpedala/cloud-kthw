module "network" {
    source              = "./modules/network"
    vnet_name           = "non-prod"
    vnet_address_space  = ["10.240.0.0/24"]
}

module "lb_masters" {
    source              = "./modules/loadbalancer"
    resource_group_name = "${module.network.resource_group_name}"
    lb_name             = "lb_master"
    protocol            = "Tcp"
    frontend_port       = 22
    backend_port        = 22
}

module "lb_workers" {
    source                = "./modules/loadbalancer"
    resource_group_name   = "${module.network.resource_group_name}"
    lb_name               = "lb_workers"
    protocol            = "Tcp"
    frontend_port       = 22
    backend_port        = 22
}

module "masters" {
  source = "./modules/instances"

  vm_prefix = "master"
  vm_count  = "${var.master_count}"
  vm_size   = "Standard_D1_v2"

  subnet_id           = "${module.network.subnet_id}"
  resource_group_name = "${module.network.resource_group_name}"

  private_ip_addresses = "${var.master_ip_addresses}"
  lb_backend_pool      = "${module.lb_masters.lb_backend_pool}"

  username = "${var.node_user}"
  ssh_key  = "${file(var.node_ssh_key)}"

}