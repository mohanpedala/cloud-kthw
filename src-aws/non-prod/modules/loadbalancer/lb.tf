resource "aws_lb" "k8s-aws_lb" {
  name               = "${var.name}-lb"
  subnets            = ["${var.subnet_id}"]
  internal           = false
  load_balancer_type = "network"
}

resource "aws_lb_target_group" "k8s-aws_lb_target_group" {
  name        = "${var.name}-lb-target-group"
  protocol    = "TCP"
  port        = 6443
  vpc_id      = "${var.vpc_id}"
  target_type = "ip"
}

resource "aws_lb_target_group_attachment" "target_group_attachment" {
  count            = "${length(var.controller_ips)}"
  target_group_arn = "${aws_lb_target_group.k8s-aws_lb_target_group.arn}"
  target_id        = "${var.controller_ips[count.index]}"
}

resource "aws_lb_listener" "front_end_listener" {
  load_balancer_arn = "${aws_lb.k8s-aws_lb.arn}"
  protocol          = "TCP"
  port              = 6443

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.k8s-aws_lb_target_group.arn}"
  }
}