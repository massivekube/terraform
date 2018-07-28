data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_ami" "controller_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["massivekube-alpinelinux-3.8-controller"]
  }

  owners = ["self"]
}
