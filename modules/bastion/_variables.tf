variable "cluster_name" {}
variable "cluster_cidr" {}
variable "vpc_id" {}

variable "subnets_public" {
  type = "list"
}

variable "bastion_instance_type" {
  default = "t2.small"
}
