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

module "certificates" {
  source = "./modules/certificates"
  apiserver_node_names  = ["${module.master.vm_hostnames}"]
  apiserver_public_ip   = ["${module.loadbalancer.k8s-aws_lb_dns_name}"]
  node_user            = "${var.node_user}" 
}

# module "kubeconfig" {
#   source = "./modules/kubeconfig"
#   node_user            = "${var.node_user}"
# }


# module "certificates" {
#   source                = "./modules/certificates"
#   kubelet_node_names    = "${module.worker.vm_hostnames}"
#   kubelet_node_ips      = "${module.worker.private_ip}"

#   apiserver_node_names  = "${module.master.vm_hostnames}"
#   apiserver_master_ips  = "${module.master.private_ip}"
#   apiserver_public_ip   = "${module.loadbalancer.k8s-aws_lb_dns_name}"
#   node_user             = "${var.node_user}"
# }

# module "kubeconfig" {
#   source = "./modules/kubeconfig"

#   kubelet_node_names   = "${module.worker.vm_hostnames}"
#   apiserver_node_names = "${module.master.vm_hostnames}"
#   kubelet_count        = "${var.worker_count}"
#   apiserver_public_ip  = "${module.loadbalancer.k8s-aws_lb_dns_name}"
#   node_user            = "${var.node_user}"

#   # kubelet_crt_pems                = "${module.certificates.kubelet_crt_pems}"
#   # kubelet_key_pems                = "${module.certificates.kubelet_key_pems}"
#   # kube-proxy_crt_pem              = "${module.certificates.kube-proxy_crt_pem}"
#   # kube-proxy_key_pem              = "${module.certificates.kube-proxy_key_pem}"
#   admin_crt_pem                   = "${module.certificates.admin_crt_pem}"
#   admin_key_pem                   = "${module.certificates.admin_key_pem}"
#   # kube-scheduler_crt_pem          = "${module.certificates.kube-scheduler_crt_pem}"
#   # kube-scheduler_key_pem          = "${module.certificates.kube-scheduler_key_pem}"
#   # kube-controller-manager_crt_pem = "${module.certificates.kube-controller-manager_crt_pem}"
#   # kube-controller-manager_key_pem = "${module.certificates.kube-controller-manager_key_pem}"
#   kube_ca_crt_pem                 = "${module.certificates.kube_ca_crt_pem}"
# }