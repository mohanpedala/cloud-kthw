# Deploy Kubernetes the hard way in AWS and Azure

## Work in progress

## Pre-Requisite
* Terraform
  - [Installing Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)
    Tested on:
      ```
      $ terraform version
      Terraform v0.12.7
      + provider.azurerm v1.33.0
      ```
* AWSCLI
  - [Installing the AWS Command Line Interface](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
* AZURECLI
  - [Installing the Azure Command Line Interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
* Kubectl
  - [Installing kubectl](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html)
* Request for a AWS account including IAM Access Keys (Access Key ID and Secret Access Key)

## How to setup setup environment

* Export AWS_ACCESS_KEY and AWS_SECRET_KEY to environment variables as shown below
  ```
  export AWS_ACCESS_KEY=**********
  export AWS_SECRET_KEY=*******************
  ```

CONS:

1. Disable public IP's generate certs with private IP's because when we stop the instances public ip's will be flushed out.

2. Remove bin in
  - The kubelet Kubernetes Configuration Files
  - The kube-proxy Kubernetes Configuration File



## Ports
#### Master node(s):
```
TCP     6443*       Kubernetes API Server
TCP     2379-2380   etcd server client API
TCP     10250       Kubelet API
TCP     10251       kube-scheduler
TCP     10252       kube-controller-manager
TCP     10255       Read-Only Kubelet API
```

#### Worker nodes (minions):
```
TCP     10250       Kubelet API
TCP     10255       Read-Only Kubelet API
TCP     30000-32767 NodePort Services
```

#### Network Weave
```
TCP     6783/6784   Weave
UDP     6783/6784   Weave
```

| SOURCE                    | DESTINATION               | PORT        | PROTOCOL          | REMARKS                                  |
|---------------------------|---------------------------|-------------|-------------------|------------------------------------------|
| Master1                   | Master2 and Master3       | 6443        | TCP               | API SERVER                               |
| Master2                   | Master1 and Master3       | 6443        | TCP               | API SERVER                               |
| Master3                   | Master1 and Master2       | 6443        | TCP               | API SERVER                               |
| Node1,NodeN               | Master1, Master2, Master3 | 6443        | TCP               | API SERVER                               |
| Master1, Master2, Master3 | Node1,NodeN               | 53          | TCP               | KUBEDNS                                  |
| Master1, Master2, Master3 | Node1,NodeN               | 10250       | TCP               | KUBELET                                  |
| Master1, Master2, Master3 | Node1,NodeN               | 22          | TCP               | SSH                                      |
| Master1                   | Master2 and Master3       | 6783 & 6784 | TCP & UDP & IPSec | WEAVE                                    |
| Master2                   | Master1 and Master3       | 6783 & 6784 | TCP & UDP & IPSec | WEAVE                                    |
| Master3                   | Master1 and Master2       | 6783 & 6784 | TCP & UDP & IPSec | WEAVE                                    |
| Master1, Master2, Master3 | Node1,NodeN               | 6783 & 6784 | TCP & UDP & IPSec | WEAVE                                    |
| Node1,NodeN               | Master1, Master2, Master3 | 6783 & 6784 | TCP & UDP & IPSec | WEAVE                                    |
| Node1                     | NodeN                     | 6783 & 6784 | TCP & UDP & IPSec | WEAVE                                    |
| NodeN                     | Node1                     | 6783 & 6784 | TCP & UDP & IPSec | WEAVE                                    |
| Node1                     | NodeN                     | 53          | TCP               | KUBEDNS                                  |
| NodeN                     | Node1                     | 53          | TCP               | KUBEDNS                                  |
| Master1                   |                           | 2379 & 2380 | TCP               | API Server and ETCD communication [2379] |
| Master2                   | Master1 and Master3       | 2379 & 2380 | TCP               | API Server and ETCD communication [2379] |
| Master3                   | Master1 and Master2       | 2379 & 2380 | TCP               | API Server and ETCD communication [2379] |
