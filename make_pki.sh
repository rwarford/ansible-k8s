#!/bin/bash

printf "\nMoving ca files to roles...\n"
rm -R roles/kubernetes-master/files/etc/kubernetes/pki/
rm -R roles/kubernetes-nodes/files/etc/kubernetes/pki/
mkdir roles/kubernetes-master/files/etc/kubernetes/pki/
mkdir roles/kubernetes-nodes/files/etc/kubernetes/pki/
cp kube-ca/$cluster_name/pki/ca.* roles/kubernetes-master/files/etc/kubernetes/pki/ 
cp kube-ca/$cluster_name/pki/ca.* roles/kubernetes-nodes/files/etc/kubernetes/pki/ 

printf "\nMaking kubelet kubeconfig file...\n"
rm -f roles/kubernetes-master/templates/etc/kubernetes/kubelet.conf.j2
kubectl --kubeconfig=roles/kubernetes-master/templates/etc/kubernetes/kubelet.conf.j2 config set-cluster $cluster_name \
        --server=https://master_ip:6443 --certificate-authority=roles/kubernetes-nodes/files/etc/kubernetes/pki/ca.crt --embed-certs=true

kubectl --kubeconfig=roles/kubernetes-master/templates/etc/kubernetes/kubelet.conf.j2 config set-credentials system:node:master \
        --username=system:node:master --client-certificate=kube-ca/$cluster_name/pki/kubelet-apiserver-client.crt \
        --client-key=kube-ca/$cluster_name/pki/kubelet-apiserver-client.key --embed-certs=true

kubectl --kubeconfig=roles/kubernetes-master/templates/etc/kubernetes/kubelet.conf.j2 config set-context system:node:master@$cluster_name --cluster=$cluster_name --user=system:node:master

kubectl --kubeconfig=roles/kubernetes-master/templates/etc/kubernetes/kubelet.conf.j2 config use-context system:node:master@$cluster_name
sed -i -e 's/master_ip/{{ master_ip }}/' roles/kubernetes-master/templates/etc/kubernetes/kubelet.conf.j2

printf "\nMaking controller-manager kubeconfig file...\n"
rm -f roles/kubernetes-master/templates/etc/kubernetes/controller-manager.conf.j2
kubectl --kubeconfig=roles/kubernetes-master/templates/etc/kubernetes/controller-manager.conf.j2 config set-cluster $cluster_name \
        --server=https://master_ip:6443 --certificate-authority=roles/kubernetes-nodes/files/etc/kubernetes/pki/ca.crt --embed-certs=true

kubectl --kubeconfig=roles/kubernetes-master/templates/etc/kubernetes/controller-manager.conf.j2 config set-credentials system:kube-controller-manager \
        --username=system:kube-controller-manager --client-certificate=kube-ca/$cluster_name/pki/controller-manager.crt \
        --client-key=kube-ca/$cluster_name/pki/controller-manager.key --embed-certs=true

kubectl --kubeconfig=roles/kubernetes-master/templates/etc/kubernetes/controller-manager.conf.j2 config set-context system:kube-controller-manager@$cluster_name --cluster=$cluster_name --user=system:kube-controller-manager

kubectl --kubeconfig=roles/kubernetes-master/templates/etc/kubernetes/controller-manager.conf.j2 config use-context system:kube-controller-manager@$cluster_name
sed -i -e 's/master_ip/{{ master_ip }}/' roles/kubernetes-master/templates/etc/kubernetes/controller-manager.conf.j2

printf "\nMaking scheduler kubeconfig file...\n"
rm -f roles/kubernetes-master/templates/etc/kubernetes/scheduler.conf.j2
kubectl --kubeconfig=roles/kubernetes-master/templates/etc/kubernetes/scheduler.conf.j2 config set-cluster $cluster_name \
        --server=https://master_ip:6443 --certificate-authority=roles/kubernetes-nodes/files/etc/kubernetes/pki/ca.crt --embed-certs=true

kubectl --kubeconfig=roles/kubernetes-master/templates/etc/kubernetes/scheduler.conf.j2 config set-credentials system:kube-scheduler \
        --username=system:kube-scheduler --client-certificate=kube-ca/$cluster_name/pki/scheduler.crt \
        --client-key=kube-ca/$cluster_name/pki/scheduler.key --embed-certs=true

kubectl --kubeconfig=roles/kubernetes-master/templates/etc/kubernetes/scheduler.conf.j2 config set-context system:kube-scheduler@$cluster_name --cluster=$cluster_name --user=system:kube-scheduler

kubectl --kubeconfig=roles/kubernetes-master/templates/etc/kubernetes/scheduler.conf.j2 config use-context system:kube-scheduler@$cluster_name
sed -i -e 's/master_ip/{{ master_ip }}/' roles/kubernetes-master/templates/etc/kubernetes/scheduler.conf.j2

printf "\nMaking admin kubeconfig file...\n"
rm -f roles/kubernetes-master/templates/etc/kubernetes/admin.conf.j2
kubectl --kubeconfig=roles/kubernetes-master/templates/etc/kubernetes/admin.conf.j2 config set-cluster $cluster_name \
        --server=https://master_ip:6443 --certificate-authority=roles/kubernetes-nodes/files/etc/kubernetes/pki/ca.crt --embed-certs=true

kubectl --kubeconfig=roles/kubernetes-master/templates/etc/kubernetes/admin.conf.j2 config set-credentials system:kube-admin \
        --username=system:kube-admin --client-certificate=kube-ca/$cluster_name/pki/admin.crt \
        --client-key=kube-ca/$cluster_name/pki/admin.key --embed-certs=true

kubectl --kubeconfig=roles/kubernetes-master/templates/etc/kubernetes/admin.conf.j2 config set-context system:kube-admin@$cluster_name --cluster=$cluster_name --user=system:kube-admin

kubectl --kubeconfig=roles/kubernetes-master/templates/etc/kubernetes/admin.conf.j2 config use-context system:kube-admin@$cluster_name
sed -i -e 's/master_ip/{{ master_ip }}/' roles/kubernetes-master/templates/etc/kubernetes/admin.conf.j2

printf "\nMaking bootstrap-kubelet kubeconfig file...\n"
rm -f ./templates/etc/kubernetes/bootstrap-kubelet.conf.j2
kubectl --kubeconfig=./templates/etc/kubernetes/bootstrap-kubelet.conf.j2 config set-cluster $cluster_name \
        --server="https://{{ master_ip }}:6443" --certificate-authority=roles/kubernetes-nodes/files/etc/kubernetes/pki/ca.crt --embed-certs=true

x='{{ hostvars[groups["kubernetes-master"][0]]["bootstrap_token"].stdout'" "'}}'
kubectl --kubeconfig=./templates/etc/kubernetes/bootstrap-kubelet.conf.j2 config set-credentials kubelet-bootstrap \
        --token "__token__"

kubectl --kubeconfig=./templates/etc/kubernetes/bootstrap-kubelet.conf.j2 config set-context kubelet-bootstrap@$cluster_name --cluster=$cluster_name --user=kubelet-bootstrap

kubectl --kubeconfig=./templates/etc/kubernetes/bootstrap-kubelet.conf.j2 config use-context kubelet-bootstrap@$cluster_name
sed -i -e 's/__token__/{{ hostvars[groups["kubernetes-master"][0]]["bootstrap_token"].stdout }}/' ./templates/etc/kubernetes/bootstrap-kubelet.conf.j2

