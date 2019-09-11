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
  ip_count                    = "${length(var.master_ips)}"
  key_name                    = "${var.key_name}"
  vpc_security_group_ids      = "${module.network.k8s-aws_security_group_id}"
  instance_type               = "t2.micro"
  count_index_private_ip      = "${var.master_ips}"
  user_data                   = "name=master"
  subnet_id                   = "${module.network.k8s-aws_subnet_id}"
  tag_suffix                  = "master"
}

module "worker" {
  source = "./modules/instances"
  ip_count                    = "${length(var.worker_ips)}"
  key_name                    = "${var.key_name}"
  vpc_security_group_ids      = "${module.network.k8s-aws_security_group_id}"
  instance_type               = "t2.micro"
  count_index_private_ip      = "${var.worker_ips}"
  subnet_id                   = "${module.network.k8s-aws_subnet_id}"
  user_data                   = "name=worker"
  worker_pod_cidrs            = "${var.worker_pod_cidrs}"
  tag_suffix                  = "worker"
}