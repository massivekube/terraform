# module "nodes" {
#   source          = "modules/nodes"
#   count           = "0"
#   cluster_name    = "${var.cluster_name}"
#   count           = "${var.node_count}"
#   instance_type   = "${var.node_instance_type}"
#   ssh_key_name    = "${var.ssh_key_name}"
#   subnets_private = "${var.subnets_private}"
#   vpc_id          = "${var.vpc_id}"
# }

