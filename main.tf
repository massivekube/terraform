module "aws_vpc" {
  source = "modules/aws_vpc"

  cluster_name = "${var.cluster_name}"
  cluster_cidr = "${var.cluster_cidr}"
}

module "kubernetes" {
  source = "modules/kubernetes"

  vpc_id          = "${module.aws_vpc.vpc_id}"
  zone_id         = "${module.aws_vpc.zone_id}"
  cluster_name    = "${var.cluster_name}"
  cluster_cidr    = "${var.cluster_cidr}"
  subnets_private = "${module.aws_vpc.subnets_private}"

  availability_zone_count = 1

  controller_instance_type = "t2.micro"
  controller_count         = 1
}
