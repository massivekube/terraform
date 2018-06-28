output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "subnets_private" {
  value = ["${aws_subnet.private.*.id}"]
}

output "nat_public_ips" {
  value = ["${aws_eip.nats.*.public_ip}"]
}
