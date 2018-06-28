# Kubernetes Controllers

The 'control plane' as it is often referred to. This module defines the autoscaling-group, and its support resources, that will house the controller nodes.

## Variables

- `count(default: 3)`: Number of controller nodes to provision.
- `instance_type(default: m4.large)`: AWS Instance type to use.

## Outputs

- `vpc_id`: VPC that was created for the cluster
- `subnets_private`: The private subnets to launch the kubernetes instances into. They will have internet access via a Nat Gateway
