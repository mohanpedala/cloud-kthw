output "k8s-aws_lb" {
  value = "${aws_lb.k8s-aws_lb.id}"
}

output "k8s-aws_lb_dns_name" {
  value = "${aws_lb.k8s-aws_lb.dns_name}"
}

