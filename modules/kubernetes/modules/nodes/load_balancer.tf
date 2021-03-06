# TODO: Enable EIPs on Kubernetes Node AWS LB

resource "aws_lb" "nodes" {
  count              = "${var.count == 0 ? 0 : 1}"
  name               = "${var.cluster_name}-nodes"
  internal           = false
  load_balancer_type = "network"
  subnets            = ["${var.subnets_private}"]

  enable_cross_zone_load_balancing = true
  enable_deletion_protection       = true

  tags {
    Environment = "${var.cluster_name}"
  }
}

resource "aws_lb_target_group" "nodes_https" {
  name     = "${var.cluster_name}-nodes-https"
  port     = 443
  protocol = "TCP"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_lb_target_group" "nodes_http" {
  name     = "${var.cluster_name}-nodes-http"
  port     = 80
  protocol = "TCP"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_lb_listener" "nodes_https" {
  count             = "${var.count == 0 ? 0 : 1}"
  load_balancer_arn = "${aws_lb.nodes.arn}"
  port              = 443
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.nodes_https.id}"
    type             = "forward"
  }
}

resource "aws_lb_listener" "nodes_http" {
  count             = "${var.count == 0 ? 0 : 1}"
  load_balancer_arn = "${aws_lb.nodes.arn}"
  port              = 80
  protocol          = "TCP"

  default_action {
    target_group_arn = "${aws_lb_target_group.nodes_http.id}"
    type             = "forward"
  }
}
