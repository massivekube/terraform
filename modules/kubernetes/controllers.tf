module "controllers" {
  source = "modules/controllers"

  ami                                = "${data.aws_ami.controller_ami.id}"
  asg_sns_topic                      = "${aws_sns_topic.asg_events.arn}"
  cluster_name                       = "${var.cluster_name}"
  count                              = "${var.controller_count}"
  instance_type                      = "${var.controller_instance_type}"
  node_security_group                = "sg-e7533d8d"
  ssh_key_name                       = "${var.ssh_key_name}"
  subnets_private                    = "${var.subnets_private}"
  vpc_id                             = "${var.vpc_id}"
  zone_id                            = "${var.zone_id}"
  aws_hostname_policy                = "${aws_iam_policy.aws_hostname.arn}"
  bastion_ssh_ingress_security_group = "${var.bastion_ssh_ingress_security_group}"
}
