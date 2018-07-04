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
  name_prefix = "controllers_dns_sd_"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "controllers_dns_sd_logging" {
  name_prefix = "controllers_dns_sd_lambda_logging_"
  role        = "${aws_iam_role.controllers_dns_sd.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "logs:PutLogEvents",
            "Resource": "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:*:*:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:*"
        },
        {
            "Effect": "Allow",
            "Action": "logs:PutLogEvents",
            "Resource": "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:*"
        },
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "controllers_dns_sd" {
  name_prefix = "controllers_dns_sd_lambda_"
  role        = "${aws_iam_role.controllers_dns_sd.id}"

  //TODO: Restrict this to a single hosted zone
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances",
                "autoscaling:DescribeAutoScalingGroups"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "route53:GetHostedZone",
                "route53:ChangeResourceRecordSets",
                "route53:ListResourceRecordSets"
            ],
            "Resource": "arn:aws:route53:::hostedzone/*"
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

resource "aws_lambda_permission" "with_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.controllers_dns_sd.arn}"
  principal     = "sns.amazonaws.com"
  source_arn    = "${aws_sns_topic.controllers_autoscaling.arn}"
}
