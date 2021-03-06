resource "aws_instance" "bastion" {
  ami                  = "${data.aws_ami.bastion_ami.id}"
  subnet_id            = "${element(aws_subnet.public_subnets.*.id, 0)}"
  instance_type        = "${var.bastion_instance_type}"
  key_name             = "massive-aws-us-east-2"
  iam_instance_profile = "${aws_iam_instance_profile.bastion.id}"
  subnet_id            = "${var.subnets_public[0]}"
  security_groups      = ["${aws_security_group.bastion.id}"]

  root_block_device {
    volume_size           = 10
    delete_on_termination = true
  }

  tags {
    Name        = "bastion"
    Envrionment = "${var.cluster_name}"
  }
}

resource "aws_eip" "bastion" {
  vpc = true

  instance = "${aws_instance.bastion.id}"
}
