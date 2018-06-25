resource "aws_launch_configuration" "nodes" {
  name                 = "${var.cluster_name}-nodes"
  image_id             = "${var.ami}"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.ssh_key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.node.id}"

  security_groups = ["${aws_security_group.nodes.id}"]

  root_block_device {
    volume_size           = "${var.root_disk_size}"
    delete_on_termination = true
  }

  // /var/log volume
  ebs_block_device {
    device_name           = "/dev/sdf"
    volume_size           = "${var.var_log_disk_size}"
    delete_on_termination = true
    encrypted             = true
  }

  // /tmp volume
  ebs_block_device {
    device_name           = "/dev/sdg"
    volume_size           = "${var.tmp_disk_size}"
    delete_on_termination = true
    encrypted             = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
