module "controllers" {
  source = "modules/controllers"

  cluster_name        = "${var.cluster_name}"
  count               = "${var.controller_count}"
  instance_type       = "${var.controller_instance_type}"
  node_security_group = "${module.nodes.node_security_group}"
  node_security_group = "${module.nodes.security_group_id}"
  ssh_key_name        = "${var.ssh_key_name}"
  subnets_private     = "${var.subnets_private}"
  vpc_id              = "${var.vpc_id}"
  zone_id             = "${var.zone_id}"
}

module "nodes" {
  source = "modules/nodes"

  cluster_name    = "${var.cluster_name}"
  count           = "${var.node_count}"
  instance_type   = "${var.node_instance_type}"
  ssh_key_name    = "${var.ssh_key_name}"
  subnets_private = "${var.subnets_private}"
  vpc_id          = "${var.vpc_id}"
}
