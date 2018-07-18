resource "aws_sns_topic_subscription" "a_record" {
  topic_arn = "${aws_sns_topic.asg_events.arn}"
  protocol  = "lambda"
  endpoint  = "${aws_lambda_function.a_record.arn}"
}

resource "aws_iam_role" "a_record" {
  name_prefix = "${var.cluster_name}_a_record"

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

resource "aws_iam_role_policy_attachment" "a_record_logging" {
  role       = "${aws_iam_role.a_record.name}"
  policy_arn = "${aws_iam_policy.logging.arn}"
}

resource "aws_iam_role_policy" "a_record" {
  name_prefix = "${var.cluster_name}_arecord_"
  role        = "${aws_iam_role.a_record.name}"

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

resource "aws_lambda_function" "a_record" {
  s3_bucket = "ma.ssive.co"
  s3_key    = "lambdas/massive_autoscaling_a_record.zip"

  function_name = "asg_a_record"
  role          = "${aws_iam_role.a_record.arn}"
  handler       = "aws-autoscalinggroup-a-record"
  runtime       = "go1.x"
  description   = "Ma.ssive Autoscaling Group A Records"
}

resource "aws_lambda_permission" "a_record" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.a_record.arn}"
  principal     = "sns.amazonaws.com"
  source_arn    = "${aws_sns_topic.asg_events.arn}"
}
