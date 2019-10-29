k8s_tag = "non-prod"

cidr_range = "10.240.0.0/24"

master_ips = ["10.240.0.10", "10.240.0.11", "10.240.0.12"]

worker_ips = ["10.240.0.20", "10.240.0.21", "10.240.0.22"]

worker_count = 3

worker_pod_cidrs = ["10.200.0.0/24", "10.200.1.0/24", "10.200.2.0/24"]

key_name = "work"

node_user = "ubuntu"