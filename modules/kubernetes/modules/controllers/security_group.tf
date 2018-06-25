resource "aws_security_group" "controllers" {
  name        = "${var.cluster_name}-controllers"
  description = "Kubernetes Controller Security Group"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name        = "Kubernetes controllers"
    Environment = "${var.cluster_name}"
  }
}

resource "aws_security_group_rule" "etcd_peer_ingress" {
  type                     = "ingress"
  from_port                = 2380
  to_port                  = 2380
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.controllers.id}"
  security_group_id        = "${aws_security_group.controllers.id}"
}

resource "aws_security_group_rule" "etcd_peer_egress" {
  type                     = "egress"
  from_port                = 2380
  to_port                  = 2380
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.controllers.id}"
  security_group_id        = "${aws_security_group.controllers.id}"
}

resource "aws_security_group_rule" "etcd_client_ingress" {
  type                     = "ingress"
  from_port                = 2379
  to_port                  = 2379
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.controllers.id}"
  security_group_id        = "${aws_security_group.controllers.id}"
}

resource "aws_security_group_rule" "etcd_client_egress" {
  type                     = "egress"
  from_port                = 2379
  to_port                  = 2379
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.controllers.id}"
  security_group_id        = "${aws_security_group.controllers.id}"
}

resource "aws_security_group_rule" "node_access" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = "${var.node_security_group}"
  security_group_id        = "${aws_security_group.controllers.id}"
}

resource "aws_security_group" "controllers_remote" {
  name        = "${var.cluster_name}-controllers-remote"
  description = "Kubernetes Controller Remote Access Security Group"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name        = "Kubernetes controllers remote access"
    Environment = "${var.cluster_name}"
  }
}
