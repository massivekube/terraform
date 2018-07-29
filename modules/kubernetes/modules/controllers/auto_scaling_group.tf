resource "aws_autoscaling_group" "controllers" {
  name_prefix          = "${var.cluster_name}_ctrl_"
  launch_configuration = "${aws_launch_configuration.controllers.name}"
  min_size             = "${var.count}"
  max_size             = "${var.count}"
  default_cooldown     = 5
  vpc_zone_identifier  = ["${var.subnets_private}"]
  termination_policies = ["OldestInstance", "ClosestToNextInstanceHour"]
  target_group_arns    = ["${aws_lb_target_group.controllers.id}"]

  tag {
    key                 = "massive:DNS-SD:ports"
    value               = "2380,2379"
    propagate_at_launch = false
  }

  tag {
    key                 = "massive:HostnamePrefix"
    value               = "ctrl-"
    propagate_at_launch = true
  }

  tag {
    key                 = "Role"
    value               = "controller"
    propagate_at_launch = true
  }

  tag {
    key                 = "massive:DNS-SD:names"
    value               = "_etcd-server-ssl._tcp.${var.cluster_name}.local,_etcd-client-ssl._tcp.${var.cluster_name}.local"
    propagate_at_launch = false
  }

  tag {
    key                 = "massive:DNS-SD:Route53:zone"
    value               = "${var.zone_id}"
    propagate_at_launch = false
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_notification" "asg_events" {
  group_names = [
    "${aws_autoscaling_group.controllers.name}",
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
  ]

  topic_arn = "${var.asg_sns_topic}"
}
