module "aws_vpc" {
  source = "modules/aws_vpc"

  cluster_name = "${var.cluster_name}"
  cluster_cidr = "${var.cluster_cidr}"
}

module "bastion" {
  source = "modules/bastion"

  subnets_public = "${module.aws_vpc.subnets_public}"
  cluster_name   = "${var.cluster_name}"
  cluster_cidr   = "${var.cluster_cidr}"
  vpc_id         = "${module.aws_vpc.vpc_id}"
}

module "kubernetes" {
  source = "modules/kubernetes"

  vpc_id                             = "${module.aws_vpc.vpc_id}"
  zone_id                            = "${module.aws_vpc.zone_id}"
  cluster_name                       = "${var.cluster_name}"
  cluster_cidr                       = "${var.cluster_cidr}"
  subnets_private                    = "${module.aws_vpc.subnets_private}"
  bastion_ssh_ingress_security_group = "${module.bastion.bastion_ssh_ingress_security_group}"

  availability_zone_count = 1

  controller_instance_type = "t2.micro"
  controller_count         = 1
}
