resource "aws_iam_instance_profile" "node" {
  name_prefix = "node-"
  role        = "${aws_iam_role.node.name}"
  path        = "/${var.cluster_name}/"
}

resource "aws_iam_role" "node" {
  name_prefix = "node-"
  path        = "/${var.cluster_name}/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
