output "bastion_ssh_ingress_security_group" {
  value = "${aws_security_group.ssh_ingress.id}"
}
