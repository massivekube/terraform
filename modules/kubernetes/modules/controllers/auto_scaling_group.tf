resource "aws_autoscaling_group" "controllers" {
  name                 = "${var.cluster_name}-controllers"
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

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    "aws_lambda_function.controllers_dns_sd",
  ]
}

resource "aws_autoscaling_notification" "example_notifications" {
  group_names = [
    "${aws_autoscaling_group.controllers.name}",
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
  ]

  topic_arn = "${aws_sns_topic.controllers_autoscaling.arn}"
}

resource "aws_sns_topic" "controllers_autoscaling" {
  display_name = "Kubernetes Controller Autoscaling"
}

resource "aws_sns_topic_subscription" "controllers_autoscaling" {
  topic_arn = "${aws_sns_topic.controllers_autoscaling.arn}"
  protocol  = "lambda"
  endpoint  = "${aws_lambda_function.controllers_dns_sd.arn}"
}

resource "aws_iam_role" "controllers_dns_sd" {
  name = "controllers_dns_sd"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "controllers_dns_sd" {
  name = "logs"
  role = "${aws_iam_role.controllers_dns_sd.arn}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "${aws_lambda_function.controllers_dns_sd.arn}"
            ]
        }
    ]
}
EOF
}

resource "aws_lambda_function" "controllers_dns_sd" {
  s3_bucket = "ma.ssive.co"
  s3_key    = "lambdas/massive_autoscaling_dns_sd.zip"

  function_name = "massive_autoscaling_DNS_SD"
  role          = "${aws_iam_role.controllers_dns_sd.arn}"
  handler       = "aws-autoscalinggroup-dns-sd"
  runtime       = "go1.x"
  description   = "Ma.ssive Autoscaling DNS-SD"
}
