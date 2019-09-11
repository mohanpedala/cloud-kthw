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

resource "aws_instance" "vms" {
  count                       = "${var.ip_count}"
  ami                         = "${data.aws_ami.ubuntu.id}"
  associate_public_ip_address = true
  key_name                    = "${var.key_name}"
  vpc_security_group_ids      = ["${var.vpc_security_group_ids}"]
  instance_type               = "${var.instance_type}"
  private_ip                  = "${var.count_index_private_ip[count.index]}"
  user_data                   = "${var.user_data}-${count.index}"
  subnet_id                   = "${var.subnet_id}"
  source_dest_check           = false

  tags = {
    Name = "${var.tag_suffix}-${count.index}"
  }
}