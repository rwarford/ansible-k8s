# Ansible Script to create a Kubernetes Cluster

I can't really recommend use of this playbook as there are so many other good ways to create a cluster now ([Rancher RKE](https://rancher.com/docs/rke/latest/en/) for example).
This MIGHT be useful for someone who wants to study the various parts of a Kubernetes control plane.

***DO NOT RUN THIS PLAYBOOK AGAINST A WORKING CLUSTER***

This script rebuilds the entire Kubernetes PKI every time. ***THIS IS PROBABLY NOT WHAT YOU WANT.*** See the localhost tasks in playbook.yml.

## Preparing to use this playbook

1. Clone this repo.
2. Change to the roles/kubernetes-nodes/files/usr/bin directory.
3. Extract the kubelet and kubectl files.

## Create a cluster
1. Create three nodes running Ubuntu 16.04 server.
   a. Set the hostname for each node.  Name the master testk8m01 and the two works testk8n01 and testk8n02.
      ```bash
      sudo hostnamectl set-hostname $nodename
      sudo vim /etc/hosts
      ``` 

   b. Install Open SSH server.
      ```bash
      sudo apt-get update
      sudo apt-get install -y openssh-server
      ``` 

   c. ON THE MASTER NODE ONLY:  Set a static IP address.
      ```bash
        sudo vim /etc/network/interfaces
      ```
     
      Edit the file to look like the following (using your IP addreess, mask, domain, and name servers):
      ```bash
        iface <interface> inet static
            address    192.168.0.100
            netmask    255.255.255.0
            gateway    192.168.0.1
            dns-search localdomain
        dns-nameservers 8.8.8.8 8.8.4.4
      ```

   d. Reboot the nodes so the changes will take effect.

   e. Push an SSH key to each node.
      ```bash
      ssh-copy-id $nodename
      ```

2. Create an ansible hosts file.

   a. Create the hosts file called hosts.test.yaml.

      The file should look like the following (***this assumes you have Freenas running and have configured a dataset for use by the Freenas provisioner***):

      ```bash
        all:
          children:
            kubernetes-master:
              hosts:
                testk8m01:
            kubernetes-nodes:
              hosts:
                testk8n01:
                testk8n02:
            kubectl-admin:
              hosts:
                <ansible hostname>:
                testk8m01:
          vars:
            cluster_name: "test-k8s"
            master_name: "{{ groups['kubernetes-master'] | first }}"
            master_ip: "{{ hostvars['testk8m01']['ansible_default_ipv4']['address'] }}"
            pod_cidr:         10.230.0.0/16
            service_cidr:     10.240.0.0/16
            cluster_dns:      10.240.0.10
            apiserver_int_ip: 10.240.0.1
            apiserver_ext_ip: "{{ hostvars['testk8m01']['ansible_default_ipv4']['address'] }}"
            loadbalancer_ip_range: 10.200.10.200-10.200.10.254
            freenas_provisioner_dataset: Mirror/kubernetes/testk8s
            freenas_host: <base64 encoded hostname>
            freenas_password: <base64 encoded password>
            ansible_python_interpreter: /usr/bin/python3
      ```

   b. Verify connectivity from the Ansible host.
      ```bash
      ansible all -m ping -i hosts.test.yaml 
      ```

3. Run the ansible playbook.
      ```bash
      ansible-playbook playbook.yml -i hosts.test.yaml
      ```

4. Go get some coffee, this is gonna take a while.

5. Enjoy your cluster (the kubeconfig file will be in .kube under your home directory, *ubuntu* in this example).
      ```bash
      kubectl --kubeconfig=/home/ubuntu/.kube/config.test-k8s get pods --all-namespaces
      ```
