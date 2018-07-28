resource "aws_launch_configuration" "controllers" {
  iam_instance_profile = "${aws_iam_instance_profile.controller.id}"
  image_id             = "${var.ami}"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.ssh_key_name}"
  name_prefix          = "${var.cluster_name}_controllers_"
  user_data            = "${data.template_file.user_data.rendered}"

  security_groups = [
    "${aws_security_group.controllers.id}",
    "${var.bastion_ssh_ingress_security_group}",
    "${aws_security_group.etcd_client.id}",
    "${aws_security_group.etcd_server.id}",
  ]

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "user_data" {
  template = "${file("${path.module}/user-data.tpl")}"
}
