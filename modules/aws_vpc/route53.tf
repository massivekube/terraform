resource "aws_route53_zone" "kubernetes" {
  name   = "${var.cluster_name}.local"
  vpc_id = "${aws_vpc.kubernetes.id}"
}
