# AWS VPC

Create a VPC to house this Kubernetes cluster.

## Variables

- `cluster_name(default: cluster.local)`: Used to identify the cluster. Also is the base of the FQDN used in the cluster.
- `cluster_cidr(default: 10.0.0.0/16)`: CIDR block used to provision the cluster IPs
- `availability_zone_count(default: 3)`: Number of availability zones we should spread this cluster over
- `instance_tenancy(default: default)`: blah

## Outputs

- `vpc_id`: VPC that was created for the cluster
- `subnets_private`: The private subnets to launch the kubernetes instances into. They will have internet access via a Nat Gateway.
- `nat_public_ips`: IPs cluster traffic will egress via.
