resource "aws_autoscaling_group" "nodes" {
  name                 = "${var.cluster_name}-nodes"
  launch_configuration = "${aws_launch_configuration.nodes.name}"
  min_size             = "${var.count}"
  max_size             = "${var.count}"
  default_cooldown     = 30
  vpc_zone_identifier  = ["${var.subnets_private}"]

  target_group_arns = [
    "${aws_lb_target_group.nodes_https.id}",
    "${aws_lb_target_group.nodes_http.id}",
  ]

  tag {
    key                 = "Environment"
    value               = "${var.cluster_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Role"
    value               = "worker"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
