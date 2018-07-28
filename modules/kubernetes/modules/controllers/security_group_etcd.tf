resource "aws_security_group" "etcd_server" {
  name        = "${var.cluster_name}-etcd-server"
  description = "Etcd Server Security Group"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name        = "etcd server"
    Environment = "${var.cluster_name}"
  }
}

resource "aws_security_group" "etcd_client" {
  name        = "${var.cluster_name}-etcd-client"
  description = "Etcd Client Security Group"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name        = "etcd client"
    Environment = "${var.cluster_name}"
  }
}

resource "aws_security_group_rule" "etcd_peer_ingress" {
  type                     = "ingress"
  from_port                = 2380
  to_port                  = 2380
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.etcd_server.id}"
  security_group_id        = "${aws_security_group.etcd_server.id}"
}

resource "aws_security_group_rule" "etcd_peer_egress" {
  type                     = "egress"
  from_port                = 2380
  to_port                  = 2380
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.etcd_server.id}"
  security_group_id        = "${aws_security_group.etcd_server.id}"
}

resource "aws_security_group_rule" "etcd_client_ingress" {
  type                     = "ingress"
  from_port                = 2379
  to_port                  = 2379
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.etcd_client.id}"
  security_group_id        = "${aws_security_group.etcd_server.id}"
}

resource "aws_security_group_rule" "etcd_client_egress" {
  type                     = "egress"
  from_port                = 2379
  to_port                  = 2379
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.etcd_server.id}"
  security_group_id        = "${aws_security_group.etcd_client.id}"
}
