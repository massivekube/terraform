output "vpc_id" {
  value = "${aws_vpc.kubernetes.id}"
}

output "zone_id" {
  value = "${aws_route53_zone.kubernetes.id}"
}

output "subnets_private" {
  value = ["${aws_subnet.private.*.id}"]
}

output "nat_public_ips" {
  value = ["${aws_eip.nats.*.public_ip}"]
}
