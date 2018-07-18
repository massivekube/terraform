resource "aws_sns_topic_subscription" "dnssd" {
  topic_arn = "${aws_sns_topic.asg_events.arn}"
  protocol  = "lambda"
  endpoint  = "${aws_lambda_function.dnssd.arn}"
}

resource "aws_iam_role" "dnssd" {
  name_prefix = "${var.cluster_name}_dnssd_"

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

resource "aws_iam_role_policy_attachment" "dnssd_logging" {
  role       = "${aws_iam_role.dnssd.name}"
  policy_arn = "${aws_iam_policy.logging.arn}"
}

resource "aws_iam_role_policy" "dnssd" {
  name_prefix = "${var.cluster_name}_dnssd_"
  role        = "${aws_iam_role.dnssd.id}"

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

resource "aws_lambda_function" "dnssd" {
  s3_bucket = "ma.ssive.co"
  s3_key    = "lambdas/massive_autoscaling_dns_sd.zip"

  function_name = "asg_${var.cluster_name}_dns_sd"
  role          = "${aws_iam_role.dnssd.arn}"
  handler       = "aws-autoscalinggroup-dns-sd"
  runtime       = "go1.x"
  description   = "Ma.ssive Autoscaling Group DNS-SD"
}

resource "aws_lambda_permission" "dnssd" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.dnssd.arn}"
  principal     = "sns.amazonaws.com"
  source_arn    = "${aws_sns_topic.asg_events.arn}"
}
