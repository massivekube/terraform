variable "cluster_name" {}
variable "cluster_cidr" {}

variable "vpc_id" {}

variable "zone_id" {}

variable "availability_zone_count" {
  default = 3
}

variable "controller_count" {
  default = 3
}

variable "controller_instance_type" {
  default = "m4.large"
}

variable "node_count" {
  default = 3
}

variable "node_instance_type" {
  default = "m4.large"
}

variable "subnets_private" {
  type = "list"
}

variable "subnets_public" {
  type    = "list"
  default = []
}

variable "ssh_key_name" {
  default = "massive-aws-us-east-2"
}
