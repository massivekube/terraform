# Kubernetes Controllers

Controller nodes are responsible for running the control plane of the cluster.

This includes:

* etcd
* kubernetes-apiserver
* kubernetes-scheduler
* kubernetes-controller

# Todo

* open etcd peer ports between controllers
* open etcd client ports between controllers
* open k8s api ports workers -> controllers
* Manage etcd dns-sd:
  * ASG notification on node launching / terminating
  * Lambda to adjust dns-sd entries for etcd on notification
  * Lambda to notify when a node is launching / terminating
