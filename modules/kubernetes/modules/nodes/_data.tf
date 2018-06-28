data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_ami" "node" {
  most_recent = true

  filter {
    name   = "name"
    values = ["massivekube-node"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["${data.aws_caller_identity.current.account_id}"]
}
