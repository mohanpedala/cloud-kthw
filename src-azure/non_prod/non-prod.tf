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

module "workers" {
  source = "./modules/instances"

  vm_prefix = "worker"
  vm_count  = "${var.worker_count}"
  vm_size   = "Standard_D1_v2"

  subnet_id           = "${module.network.subnet_id}"
  resource_group_name = "${module.network.resource_group_name}"

  private_ip_addresses = "${var.worker_ip_addresses}"
  lb_backend_pool      = "${module.lb_workers.lb_backend_pool}"

  username = "${var.node_user}"
  ssh_key  = "${file(var.node_ssh_key)}"
}

module "certificates" {
  source = "./modules/certificates"

  kubelet_node_names   = "${module.workers.names}"
  apiserver_node_names = "${module.masters.names}"

  kubelet_node_ips = "${module.workers.private_ip_addresses}"

  apiserver_master_ips = "${module.masters.private_ip_addresses}"
  apiserver_public_ip  = "${module.lb_masters.public_ip_address}"

  node_user = "${var.node_user}"
}

module "kubeconfig" {
  source = "./modules/kubeconfig"

  kubelet_node_names   = "${module.workers.names}"
  apiserver_node_names = "${module.masters.names}"
  kubelet_count        = "${var.worker_count}"
  apiserver_public_ip  = "${module.lb_masters.public_ip_address}"
  node_user            = "${var.node_user}"

  kubelet_crt_pems                = "${module.certificates.kubelet_crt_pems}"
  kubelet_key_pems                = "${module.certificates.kubelet_key_pems}"
  kube-proxy_crt_pem              = "${module.certificates.kube-proxy_crt_pem}"
  kube-proxy_key_pem              = "${module.certificates.kube-proxy_key_pem}"
  admin_crt_pem                   = "${module.certificates.admin_crt_pem}"
  admin_key_pem                   = "${module.certificates.admin_key_pem}"
  kube-scheduler_crt_pem          = "${module.certificates.kube-scheduler_crt_pem}"
  kube-scheduler_key_pem          = "${module.certificates.kube-scheduler_key_pem}"
  kube-controller-manager_crt_pem = "${module.certificates.kube-controller-manager_crt_pem}"
  kube-controller-manager_key_pem = "${module.certificates.kube-controller-manager_key_pem}"
  kube_ca_crt_pem                 = "${module.certificates.kube_ca_crt_pem}"
}

module "encryption_config" {
  source               = "./modules/encryption_config"
  apiserver_node_names = "${module.masters.names}"
  apiserver_public_ip  = "${module.lb_masters.public_ip_address}"

  node_user = "${var.node_user}"
}

module "etcd" {
  source                = "./modules/etcd"
  apiserver_node_names  = "${module.masters.names}"
  apiserver_public_ip   = "${module.lb_masters.public_ip_address}"
  apiserver_private_ips = "${var.master_ip_addresses}"

  node_user = "${var.node_user}"

  kubernetes_certs_null_ids = "${module.certificates.kubernetes_certs_null_ids}"
  ca_cert_null_ids          = "${module.certificates.ca_cert_null_ids}"
}