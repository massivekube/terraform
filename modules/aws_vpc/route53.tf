resource "aws_route53_zone" "kubernetes" {
  name   = "${var.cluster_name}"
  vpc_id = "${aws_vpc.kubernetes.id}"
}
