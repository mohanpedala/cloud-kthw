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