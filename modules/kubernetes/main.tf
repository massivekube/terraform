module "controllers" {
  source = "modules/controllers"
  count  = 3

  ami                 = "ami-08bf826d"
  cluster_name        = "${var.cluster_name}"
  ssh_key_name        = "${var.ssh_key_name}"
  subnets_private     = "${var.subnets_private}"
  vpc_id              = "${var.vpc_id}"
  node_security_group = "sg-892c75ff"

  node_security_group = "${module.nodes.security_group_id}"
  instance_type       = "t2.nano"
}

module "nodes" {
  source = "modules/nodes"
  count  = 3

  ami             = "ami-08bf826d"
  cluster_name    = "${var.cluster_name}"
  ssh_key_name    = "${var.ssh_key_name}"
  subnets_private = "${var.subnets_private}"
  vpc_id          = "${var.vpc_id}"
}
