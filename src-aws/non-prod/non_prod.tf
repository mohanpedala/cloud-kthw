module "network" {
    source      = "./modules/network"
    k8s_tag     = "non-prod"
    cidr_range  = "10.240.0.0/24"
}