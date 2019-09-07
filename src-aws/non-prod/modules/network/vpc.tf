resource "aws_vpc" "k8s-aws_vpc" {
  cidr_block           = "${var.cidr_range}"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "${var.k8s_tag}"
  }
}

resource "aws_vpc_dhcp_options" "k8s-aws_vpc_dhcp_options" {
  domain_name         = "${var.aws_region}.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = {
    Name = "${var.k8s_tag}"
  }
}

resource "aws_vpc_dhcp_options_association" "k8s-aws_vpc_dhcp_options_association" {
  vpc_id          = "${aws_vpc.k8s-aws_vpc.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.k8s-aws_vpc_dhcp_options.id}"
}

resource "aws_subnet" "k8s-aws_subnet" {
  vpc_id     = "${aws_vpc.k8s-aws_vpc.id}"
  cidr_block = "${var.cidr_range}"

  tags = {
    Name = "${var.k8s_tag}"
  }
}

resource "aws_internet_gateway" "k8s-aws_internet_gateway" {
  vpc_id = "${aws_vpc.k8s-aws_vpc.id}"

  tags = {
    Name = "${var.k8s_tag}"
  }
}

resource "aws_route_table" "k8s-aws_route_table" {
  vpc_id = "${aws_vpc.k8s-aws_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.k8s-aws_internet_gateway.id}"
  }

  tags = {
    Name = "${var.k8s_tag}"
  }
}

resource "aws_route_table_association" "k8s-aws_route_table_association" {
  subnet_id      = "${aws_subnet.k8s-aws_subnet.id}"
  route_table_id = "${aws_route_table.k8s-aws_route_table.id}"
}

resource "aws_security_group" "k8s-aws_security_group" {
  name        = "kubernetes"
  description = "Kubernetes security group"
  vpc_id      = "${aws_vpc.k8s-aws_vpc.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.240.0.0/24", "10.200.0.0/16"]
  }

  ingress {
    from_port   = 0
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # May be wrong
  ingress {
    from_port   = 0
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.k8s_tag}"
  }
}