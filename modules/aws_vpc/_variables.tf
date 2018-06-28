variable "cluster_name" {
  default = "cluster.local"
}

variable "cluster_cidr" {
  default = "10.0.0.0/16"
}

variable "availability_zone_count" {
  default = 3
}

variable "instance_tenancy" {
  default = "default"
}
