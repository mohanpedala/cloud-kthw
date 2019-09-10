data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "master" {
  count                       = "${length(var.master_ips)}"
  ami                         = "${data.aws_ami.ubuntu.id}"
  associate_public_ip_address = true
  key_name                    = "${var.key_name}"                                       # "${aws_key_pair.k8s.key_name}"
  vpc_security_group_ids      = ["${var.vpc_security_group_ids}"]
  instance_type               = "${var.instance_type}"
  private_ip                  = "${var.master_ips[count.index]}"
  user_data                   = "name=master-${count.index}"
  subnet_id                   = "${var.subnet_id}"
  source_dest_check           = false

  tags = {
    Name = "master-${count.index}"
  }
}

resource "aws_instance" "worker" {
  count                       = "${length(var.worker_ips)}"
  ami                         = "${data.aws_ami.ubuntu.id}"
  associate_public_ip_address = true
  key_name                    = "${var.key_name}"                                       # "${aws_key_pair.k8s.key_name}"
  vpc_security_group_ids      = ["${var.vpc_security_group_ids}"]
  instance_type               = "${var.instance_type}"
  private_ip                  = "${var.worker_ips[count.index]}"
  user_data                   = "name=worker-${count.index}|pod-cidr=${var.worker_pod_cidrs[count.index]}"
  subnet_id                   = "${var.subnet_id}"
  source_dest_check           = false

  tags = {
    Name = "worker-${count.index}"
  }
}