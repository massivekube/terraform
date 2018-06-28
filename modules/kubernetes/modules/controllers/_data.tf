data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_ami" "controller" {
  most_recent = true

  filter {
    name   = "name"
    values = ["massivekube-controller"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["${data.aws_caller_identity.current.account_id}"]
}
