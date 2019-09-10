output "k8s-aws_subnet_id" {
  value = "${aws_subnet.k8s-aws_subnet.id}"
}

output "k8s-aws_vpc_id" {
  value = "${aws_vpc.k8s-aws_vpc.id}"
}