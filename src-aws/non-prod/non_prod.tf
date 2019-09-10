module "network" {
    source      = "./modules/network"
    name        = "${var.k8s_tag}"
    k8s_tag     = "${var.k8s_tag}"
    cidr_range  = "10.240.0.0/24"
}

module "loadbalancer" {
  source    = "./modules/loadbalancer"
  name      = "${var.k8s_tag}"
  subnet_id = "${module.network.k8s-aws_subnet_id}"
  vpc_id    = "${module.network.k8s-aws_vpc_id}"
}
