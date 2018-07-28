resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "Bastion node Security Group"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name        = "bastion"
    Environment = "${var.cluster_name}"
  }
}

resource "aws_security_group_rule" "bastion_ssh_egress" {
  type              = "egress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${var.cluster_cidr}"]
  security_group_id = "${aws_security_group.bastion.id}"
}

resource "aws_security_group" "ssh_ingress" {
  name        = "ssh_ingress"
  description = "Allow inbound ssh connections"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name        = "ssh_ingress"
    Environment = "${var.cluster_name}"
  }
}

resource "aws_security_group_rule" "bastion_ssh_ingress" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.bastion.id}"
  security_group_id        = "${aws_security_group.ssh_ingress.id}"
}
