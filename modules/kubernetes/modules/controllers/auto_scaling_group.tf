resource "aws_autoscaling_group" "controllers" {
  name_prefix          = "${var.cluster_name}_controllers_"
  launch_configuration = "${aws_launch_configuration.controllers.name}"
  min_size             = "${var.count}"
  max_size             = "${var.count}"
  default_cooldown     = 30
  vpc_zone_identifier  = ["${var.subnets_private}"]

  target_group_arns = ["${aws_lb_target_group.controllers.id}"]

  tag {
    key                 = "massive:DNS-SD:ports"
    value               = "2380,2379"
    propagate_at_launch = false
  }

  tag {
    key                 = "massive:DNS-SD:names"
    value               = "_etcd-server-ssl._tcp.development.local,_etcd-client-ssl._tcp.development.local"
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

module "controller_dns_sd" {
  source                     = "git@github.com:massiveco/aws-autoscalinggroup-dns-sd.git//terraform"
  display_name               = "controllers"
  aws_autoscaling_group_name = "${aws_autoscaling_group.controllers.name}"
}
