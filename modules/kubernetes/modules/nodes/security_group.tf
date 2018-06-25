resource "aws_security_group" "nodes" {
  name        = "${var.cluster_name}-nodes"
  description = "Kubernetes worker Security Group"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name        = "Kubernetes nodes"
    Environment = "${var.cluster_name}"
  }
}
