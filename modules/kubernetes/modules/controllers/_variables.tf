variable "vpc_id" {}

variable "ami" {}

variable "count" {
  default = 3
}

variable "aws_hostname_policy" {}

variable "cluster_name" {}
variable "zone_id" {}

variable "ssh_key_name" {}

variable "instance_type" {
  default = "m4.large"
}

variable "root_disk_size" {
  default = 32
}

variable "var_log_disk_size" {
  default = 32
}

variable "tmp_disk_size" {
  default = 32
}

variable "subnets_private" {
  type = "list"
}

variable "node_security_group" {}

variable "bastion_ssh_ingress_security_group" {}

variable "asg_sns_topic" {}
