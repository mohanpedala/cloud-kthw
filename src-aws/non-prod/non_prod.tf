module "network" {
    source      = "./modules/network"
    name        = "${var.k8s_tag}"
    k8s_tag     = "${var.k8s_tag}"
    cidr_range  = "${var.cidr_range}"
}

module "loadbalancer" {
  source        = "./modules/loadbalancer"
  name          = "${var.k8s_tag}"
  subnet_id     = "${module.network.k8s-aws_subnet_id}"
  vpc_id        = "${module.network.k8s-aws_vpc_id}"
  master_ips    = "${var.master_ips}"
  k8s_tag       = "${var.k8s_tag}"
}

module "master" {
  source = "./modules/instances"
  key_name                    = "${var.key_name}"                                       # "${aws_key_pair.k8s.key_name}"
  vpc_security_group_ids      = "${module.network.k8s-aws_security_group_id}"
  instance_type               = "t2.micro"
  master_ips                  = "${var.master_ips}"
  worker_ips                  = "${var.worker_ips}"
  subnet_id                   = "${module.network.k8s-aws_subnet_id}"
  worker_pod_cidrs            = "${var.worker_pod_cidrs}"
}