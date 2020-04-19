#!/bin/bash

# remove components that were added during initialization
kubectl delete -f coredns.yaml
kubectl delete -f kube-proxy-rbac.yaml
kubectl delete -f kube-proxy-cm.yaml
kubectl delete -f kube-proxy-ds.yaml

# remove all nodes
NODES=$(kubectl get nodes --selector '!node-role.kubernetes.io/master' --output custom-columns=:.metadata.name --no-headers)
kubectl drain $NODES --ignore-daemonsets
kubectl delete nodes $NODES

sudo systemctl stop kubelet

sudo iptables -F && sudo iptables -t nat -F && sudo iptables -t mangle -F && sudo iptables -X

sudo docker kill $(sudo docker ps -q)
sudo docker rm $(sudo docker ps -a -q)
sudo rm -R /etc/kubernetes/
sudo rm -R /var/lib/kubelet/
sudo rm -R /var/lib/etcd/
