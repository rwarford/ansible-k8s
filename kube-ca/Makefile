.PHONY : clean all


#
# Set the following environment variables before running make:
#
# cluster_name
# master_name
# apiserver_ext_ip
# apiserver_int_ip
#

include make.env

export cluster_name ?= k8s
master_name ?= master
apiserver_ext_ip ?= 192.168.1.1
apiserver_int_ip ?= 10.10.10.1

# Get the absolute path to this makefile
MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
ROOT_DIR=$(patsubst %/,%,$(dir $(MAKEFILE_PATH)))

CONF_DIR=$(ROOT_DIR)/conf
PKI_DIR=$(ROOT_DIR)/$(cluster_name)

all: test-env $(PKI_DIR)/pki

test-env: 
	@echo Country: $${CA_COUNTRY}
	@echo State: $${CA_STATE}
	@echo Locality: $${CA_LOCALITY}
	@echo EMail: $${CA_EMAIL}

$(PKI_DIR)/pki: \
	 $(PKI_DIR)/root-ca/certs/root-ca.crt \
     $(PKI_DIR)/kubernetes-ca/certs/kubernetes-ca.crt \
     $(PKI_DIR)/kubernetes-ca/certs/apiserver.crt \
     $(PKI_DIR)/kubernetes-ca/certs/apiserver-to-kubelet.crt \
     $(PKI_DIR)/kubernetes-ca/certs/kubelet-to-apiserver.crt \
     $(PKI_DIR)/kubernetes-ca/certs/controller-manager.crt \
     $(PKI_DIR)/kubernetes-ca/certs/scheduler.crt \
     $(PKI_DIR)/kubernetes-ca/certs/admin.crt \
     $(PKI_DIR)/etcd-ca/certs/etcd-ca.crt \
     $(PKI_DIR)/etcd-ca/certs/apiserver-to-etcd.crt \
     $(PKI_DIR)/etcd-ca/certs/etcd-peer.crt \
     $(PKI_DIR)/etcd-ca/certs/etcd-server.crt \
     $(PKI_DIR)/etcd-ca/certs/healthcheck-client.crt \
     $(PKI_DIR)/front-proxy-ca/certs/front-proxy-ca.crt \
     $(PKI_DIR)/front-proxy-ca/certs/front-proxy-client.crt
	mkdir -p $(PKI_DIR)/pki/etcd
	openssl x509 -in $(PKI_DIR)/kubernetes-ca/certs/apiserver.crt >$(PKI_DIR)/pki/apiserver.crt
	openssl x509 -in $(PKI_DIR)/kubernetes-ca/certs/apiserver-to-kubelet.crt >$(PKI_DIR)/pki/apiserver-kubelet-client.crt
	openssl x509 -in $(PKI_DIR)/kubernetes-ca/certs/kubelet-to-apiserver.crt >$(PKI_DIR)/pki/kubelet-apiserver-client.crt
	openssl x509 -in $(PKI_DIR)/kubernetes-ca/certs/controller-manager.crt >$(PKI_DIR)/pki/controller-manager.crt
	openssl x509 -in $(PKI_DIR)/kubernetes-ca/certs/scheduler.crt >$(PKI_DIR)/pki/scheduler.crt
	openssl x509 -in $(PKI_DIR)/kubernetes-ca/certs/admin.crt >$(PKI_DIR)/pki/admin.crt
	openssl x509 -in $(PKI_DIR)/kubernetes-ca/certs/kubernetes-ca.crt >$(PKI_DIR)/pki/ca.crt
	openssl x509 -in $(PKI_DIR)/etcd-ca/certs/etcd-ca.crt >$(PKI_DIR)/pki/etcd/ca.crt
	openssl x509 -in $(PKI_DIR)/etcd-ca/certs/apiserver-to-etcd.crt >$(PKI_DIR)/pki/apiserver-etcd-client.crt
	openssl x509 -in $(PKI_DIR)/etcd-ca/certs/etcd-peer.crt >$(PKI_DIR)/pki/etcd/peer.crt
	openssl x509 -in $(PKI_DIR)/etcd-ca/certs/etcd-server.crt >$(PKI_DIR)/pki/etcd/server.crt
	openssl x509 -in $(PKI_DIR)/etcd-ca/certs/healthcheck-client.crt >$(PKI_DIR)/pki/etcd/healthcheck-client.crt
	openssl x509 -in $(PKI_DIR)/front-proxy-ca/certs/front-proxy-ca.crt >$(PKI_DIR)/pki/front-proxy-ca.crt
	openssl x509 -in $(PKI_DIR)/front-proxy-ca/certs/front-proxy-client.crt >$(PKI_DIR)/pki/front-proxy-client.crt
	cp $(PKI_DIR)/kubernetes-ca/keys/apiserver.key $(PKI_DIR)/pki/
	cp $(PKI_DIR)/kubernetes-ca/keys/apiserver-to-kubelet.key $(PKI_DIR)/pki/apiserver-kubelet-client.key
	cp $(PKI_DIR)/kubernetes-ca/keys/kubelet-to-apiserver.key $(PKI_DIR)/pki/kubelet-apiserver-client.key
	cp $(PKI_DIR)/kubernetes-ca/keys/controller-manager.key $(PKI_DIR)/pki/controller-manager.key
	cp $(PKI_DIR)/kubernetes-ca/keys/scheduler.key $(PKI_DIR)/pki/scheduler.key
	cp $(PKI_DIR)/kubernetes-ca/keys/admin.key $(PKI_DIR)/pki/admin.key
	cp $(PKI_DIR)/kubernetes-ca/keys/kubernetes-ca.key $(PKI_DIR)/pki/ca.key
	cp $(PKI_DIR)/etcd-ca/keys/etcd-ca.key $(PKI_DIR)/pki/etcd/ca.key
	cp $(PKI_DIR)/etcd-ca/keys/apiserver-to-etcd.key $(PKI_DIR)/pki/apiserver-etcd-client.key
	cp $(PKI_DIR)/etcd-ca/keys/etcd-peer.key $(PKI_DIR)/pki/etcd/peer.key
	cp $(PKI_DIR)/etcd-ca/keys/etcd-server.key $(PKI_DIR)/pki/etcd/server.key
	cp $(PKI_DIR)/etcd-ca/keys/healthcheck-client.key $(PKI_DIR)/pki/etcd/healthcheck-client.key
	cp $(PKI_DIR)/front-proxy-ca/keys/front-proxy-ca.key $(PKI_DIR)/pki/front-proxy-ca.key
	cp $(PKI_DIR)/front-proxy-ca/keys/front-proxy-client.key $(PKI_DIR)/pki/front-proxy-client.key
	openssl genrsa -out $(PKI_DIR)/pki/sa.key
	openssl rsa -in $(PKI_DIR)/pki/sa.key -outform PEM -pubout -out $(PKI_DIR)/pki/sa.pub
	touch $(PKI_DIR)/pki # make sure the timestamp on the pki directory is updated


# root-ca structure
$(PKI_DIR)/root-ca:
	./make_ca.sh $(PKI_DIR) root-ca

# root-ca csr
$(PKI_DIR)/root-ca/keys/root-ca.key $(PKI_DIR)/root-ca/csr/root-ca.csr: $(PKI_DIR)/root-ca $(CONF_DIR)/root-ca.conf
	openssl req -new -config conf/root-ca.conf -out $(PKI_DIR)/root-ca/csr/root-ca.csr -keyout $(PKI_DIR)/root-ca/keys/root-ca.key

# root-ca cert
$(PKI_DIR)/root-ca/certs/root-ca.crt: $(PKI_DIR)/root-ca/csr/root-ca.csr $(CONF_DIR)/root-ca.conf
	openssl ca -batch -selfsign -config $(CONF_DIR)/root-ca.conf -in $(PKI_DIR)/root-ca/csr/root-ca.csr -out $(PKI_DIR)/root-ca/certs/root-ca.crt


# kubernetes-ca structure
$(PKI_DIR)/kubernetes-ca:
	./make_ca.sh $(PKI_DIR) kubernetes-ca

# kubernetes-ca csr
$(PKI_DIR)/kubernetes-ca/keys/kubernetes-ca.key $(PKI_DIR)/root-ca/csr/kubernetes-ca.csr: $(PKI_DIR)/kubernetes-ca $(CONF_DIR)/kubernetes-ca.csr.conf
	openssl req -new -config $(CONF_DIR)/kubernetes-ca.csr.conf -out $(PKI_DIR)/root-ca/csr/kubernetes-ca.csr -keyout $(PKI_DIR)/kubernetes-ca/keys/kubernetes-ca.key

# kubernetes-ca cert
$(PKI_DIR)/kubernetes-ca/certs/kubernetes-ca.crt : $(PKI_DIR)/root-ca/csr/kubernetes-ca.csr $(CONF_DIR)/root-ca.conf
	#openssl ca -batch -config $(CONF_DIR)/root-ca.conf -in $(PKI_DIR)/root-ca/csr/kubernetes-ca.csr -out $(PKI_DIR)/kubernetes-ca/certs/kubernetes-ca.crt
	cp $(PKI_DIR)/root-ca/certs/root-ca.crt $(PKI_DIR)/kubernetes-ca/certs/kubernetes-ca.crt
	cp $(PKI_DIR)/root-ca/keys/root-ca.key $(PKI_DIR)/kubernetes-ca/keys/kubernetes-ca.key

# kubernetes API Server csr
$(PKI_DIR)/kubernetes-ca/keys/apiserver.key $(PKI_DIR)/kubernetes-ca/csr/apiserver.csr: $(PKI_DIR)/kubernetes-ca $(CONF_DIR)/apiserver.csr.conf
	openssl req -new -config $(CONF_DIR)/apiserver.csr.conf -out $(PKI_DIR)/kubernetes-ca/csr/apiserver.csr -keyout $(PKI_DIR)/kubernetes-ca/keys/apiserver.key

# kubernetes API Server cert
$(PKI_DIR)/kubernetes-ca/certs/apiserver.crt: $(PKI_DIR)/kubernetes-ca/csr/apiserver.csr $(CONF_DIR)/kubernetes-ca.conf
	openssl ca -batch -config $(CONF_DIR)/kubernetes-ca.conf -in $(PKI_DIR)/kubernetes-ca/csr/apiserver.csr -out $(PKI_DIR)/kubernetes-ca/certs/apiserver.crt

# kubelet-to-apiserver csr
$(PKI_DIR)/kubernetes-ca/keys/kubelet-to-apiserver.key $(PKI_DIR)/kubernetes-ca/csr/kubelet-to-apiserver.csr: $(PKI_DIR)/kubernetes-ca $(CONF_DIR)/kubelet-to-apiserver.csr.conf
	openssl req -new -config $(CONF_DIR)/kubelet-to-apiserver.csr.conf -out $(PKI_DIR)/kubernetes-ca/csr/kubelet-to-apiserver.csr -keyout $(PKI_DIR)/kubernetes-ca/keys/kubelet-to-apiserver.key

# kubelet-to-apiserver cert
$(PKI_DIR)/kubernetes-ca/certs/kubelet-to-apiserver.crt: $(PKI_DIR)/kubernetes-ca/csr/kubelet-to-apiserver.csr $(CONF_DIR)/kubernetes-ca.conf
	openssl ca -batch -config $(CONF_DIR)/kubernetes-ca.conf -in $(PKI_DIR)/kubernetes-ca/csr/kubelet-to-apiserver.csr -out $(PKI_DIR)/kubernetes-ca/certs/kubelet-to-apiserver.crt

# apiserver-to-kubelet csr
$(PKI_DIR)/kubernetes-ca/keys/apiserver-to-kubelet.key $(PKI_DIR)/kubernetes-ca/csr/apiserver-to-kubelet.csr: $(PKI_DIR)/kubernetes-ca $(CONF_DIR)/apiserver-to-kubelet.csr.conf
	openssl req -new -config $(CONF_DIR)/apiserver-to-kubelet.csr.conf -out $(PKI_DIR)/kubernetes-ca/csr/apiserver-to-kubelet.csr -keyout $(PKI_DIR)/kubernetes-ca/keys/apiserver-to-kubelet.key

# apiserver-to-kubelet cert
$(PKI_DIR)/kubernetes-ca/certs/apiserver-to-kubelet.crt: $(PKI_DIR)/kubernetes-ca/csr/apiserver-to-kubelet.csr $(CONF_DIR)/kubernetes-ca.conf
	openssl ca -batch -config $(CONF_DIR)/kubernetes-ca.conf -in $(PKI_DIR)/kubernetes-ca/csr/apiserver-to-kubelet.csr -out $(PKI_DIR)/kubernetes-ca/certs/apiserver-to-kubelet.crt

# controller-manager csr
$(PKI_DIR)/kubernetes-ca/keys/controller-manager.key $(PKI_DIR)/kubernetes-ca/csr/controller-manager.csr: $(PKI_DIR)/kubernetes-ca $(CONF_DIR)/controller-manager.csr.conf
	openssl req -new -config $(CONF_DIR)/controller-manager.csr.conf -out $(PKI_DIR)/kubernetes-ca/csr/controller-manager.csr -keyout $(PKI_DIR)/kubernetes-ca/keys/controller-manager.key

# controller-manager cert
$(PKI_DIR)/kubernetes-ca/certs/controller-manager.crt: $(PKI_DIR)/kubernetes-ca/csr/controller-manager.csr $(CONF_DIR)/kubernetes-ca.conf
	openssl ca -batch -config $(CONF_DIR)/kubernetes-ca.conf -in $(PKI_DIR)/kubernetes-ca/csr/controller-manager.csr -out $(PKI_DIR)/kubernetes-ca/certs/controller-manager.crt

# scheduler csr
$(PKI_DIR)/kubernetes-ca/keys/scheduler.key $(PKI_DIR)/kubernetes-ca/csr/scheduler.csr: $(PKI_DIR)/kubernetes-ca $(CONF_DIR)/scheduler.csr.conf
	openssl req -new -config $(CONF_DIR)/scheduler.csr.conf -out $(PKI_DIR)/kubernetes-ca/csr/scheduler.csr -keyout $(PKI_DIR)/kubernetes-ca/keys/scheduler.key

# scheduler cert
$(PKI_DIR)/kubernetes-ca/certs/scheduler.crt: $(PKI_DIR)/kubernetes-ca/csr/scheduler.csr $(CONF_DIR)/kubernetes-ca.conf
	openssl ca -batch -config $(CONF_DIR)/kubernetes-ca.conf -in $(PKI_DIR)/kubernetes-ca/csr/scheduler.csr -out $(PKI_DIR)/kubernetes-ca/certs/scheduler.crt

# admin csr
$(PKI_DIR)/kubernetes-ca/keys/admin.key $(PKI_DIR)/kubernetes-ca/csr/admin.csr: $(PKI_DIR)/kubernetes-ca $(CONF_DIR)/admin.csr.conf
	openssl req -new -config $(CONF_DIR)/admin.csr.conf -out $(PKI_DIR)/kubernetes-ca/csr/admin.csr -keyout $(PKI_DIR)/kubernetes-ca/keys/admin.key

# admin cert
$(PKI_DIR)/kubernetes-ca/certs/admin.crt: $(PKI_DIR)/kubernetes-ca/csr/admin.csr $(CONF_DIR)/kubernetes-ca.conf
	openssl ca -batch -config $(CONF_DIR)/kubernetes-ca.conf -in $(PKI_DIR)/kubernetes-ca/csr/admin.csr -out $(PKI_DIR)/kubernetes-ca/certs/admin.crt


# etcd-ca structure
$(PKI_DIR)/etcd-ca:
	./make_ca.sh $(PKI_DIR) etcd-ca

# etcd-ca csr
$(PKI_DIR)/etcd-ca/keys/etcd-ca.key $(PKI_DIR)/root-ca/csr/etcd-ca.csr: $(PKI_DIR)/etcd-ca $(CONF_DIR)/etcd-ca.csr.conf
	openssl req -new -config $(CONF_DIR)/etcd-ca.csr.conf -out $(PKI_DIR)/root-ca/csr/etcd-ca.csr -keyout $(PKI_DIR)/etcd-ca/keys/etcd-ca.key

# etcd-ca cert
$(PKI_DIR)/etcd-ca/certs/etcd-ca.crt : $(PKI_DIR)/root-ca/csr/etcd-ca.csr $(CONF_DIR)/root-ca.conf
	openssl ca -batch -config $(CONF_DIR)/root-ca.conf -in $(PKI_DIR)/root-ca/csr/etcd-ca.csr -out $(PKI_DIR)/etcd-ca/certs/etcd-ca.crt

# apiserver-to-etcd csr
$(PKI_DIR)/etcd-ca/keys/apiserver-to-etcd.key $(PKI_DIR)/etcd-ca/csr/apiserver-to-etcd.csr: $(PKI_DIR)/etcd-ca $(CONF_DIR)/apiserver-to-etcd.csr.conf
	openssl req -new -config $(CONF_DIR)/apiserver-to-etcd.csr.conf -out $(PKI_DIR)/etcd-ca/csr/apiserver-to-etcd.csr -keyout $(PKI_DIR)/etcd-ca/keys/apiserver-to-etcd.key

# apiserver-to-etcd cert
$(PKI_DIR)/etcd-ca/certs/apiserver-to-etcd.crt: $(PKI_DIR)/etcd-ca/csr/apiserver-to-etcd.csr $(CONF_DIR)/etcd-ca.conf
	openssl ca -batch -config $(CONF_DIR)/etcd-ca.conf -in $(PKI_DIR)/etcd-ca/csr/apiserver-to-etcd.csr -out $(PKI_DIR)/etcd-ca/certs/apiserver-to-etcd.crt

# etcd peer certificate
$(PKI_DIR)/etcd-ca/keys/etcd-peer.key $(PKI_DIR)/etcd-ca/csr/etcd-peer.csr: $(PKI_DIR)/etcd-ca $(CONF_DIR)/etcd-peer.csr.conf
	openssl req -new -config $(CONF_DIR)/etcd-peer.csr.conf -out $(PKI_DIR)/etcd-ca/csr/etcd-peer.csr -keyout $(PKI_DIR)/etcd-ca/keys/etcd-peer.key

# etcd peer certificate
$(PKI_DIR)/etcd-ca/certs/etcd-peer.crt: $(PKI_DIR)/etcd-ca/csr/etcd-peer.csr $(CONF_DIR)/etcd-ca.conf
	openssl ca -batch -config $(CONF_DIR)/etcd-ca.conf -in $(PKI_DIR)/etcd-ca/csr/etcd-peer.csr -out $(PKI_DIR)/etcd-ca/certs/etcd-peer.crt

# etcd server certificate
$(PKI_DIR)/etcd-ca/keys/etcd-server.key $(PKI_DIR)/etcd-ca/csr/etcd-server.csr: $(PKI_DIR)/etcd-ca $(CONF_DIR)/etcd-server.csr.conf
	openssl req -new -config $(CONF_DIR)/etcd-server.csr.conf -out $(PKI_DIR)/etcd-ca/csr/etcd-server.csr -keyout $(PKI_DIR)/etcd-ca/keys/etcd-server.key

# etcd server certificate
$(PKI_DIR)/etcd-ca/certs/etcd-server.crt: $(PKI_DIR)/etcd-ca/csr/etcd-server.csr $(CONF_DIR)/etcd-ca.conf
	openssl ca -batch -config $(CONF_DIR)/etcd-ca.conf -in $(PKI_DIR)/etcd-ca/csr/etcd-server.csr -out $(PKI_DIR)/etcd-ca/certs/etcd-server.crt

# healthcheck-client csr
$(PKI_DIR)/etcd-ca/keys/healthcheck-client.key $(PKI_DIR)/etcd-ca/csr/healthcheck-client.csr: $(PKI_DIR)/etcd-ca $(CONF_DIR)/healthcheck-client.csr.conf
	openssl req -new -config $(CONF_DIR)/healthcheck-client.csr.conf -out $(PKI_DIR)/etcd-ca/csr/healthcheck-client.csr -keyout $(PKI_DIR)/etcd-ca/keys/healthcheck-client.key

# healthcheck-client cert
$(PKI_DIR)/etcd-ca/certs/healthcheck-client.crt: $(PKI_DIR)/etcd-ca/csr/healthcheck-client.csr $(CONF_DIR)/etcd-ca.conf
	openssl ca -batch -config $(CONF_DIR)/etcd-ca.conf -in $(PKI_DIR)/etcd-ca/csr/healthcheck-client.csr -out $(PKI_DIR)/etcd-ca/certs/healthcheck-client.crt

# front-proxy-ca structure
$(PKI_DIR)/front-proxy-ca:
	./make_ca.sh $(PKI_DIR) front-proxy-ca

# front-proxy-ca csr
$(PKI_DIR)/front-proxy-ca/keys/front-proxy-ca.key $(PKI_DIR)/root-ca/csr/front-proxy-ca.csr: $(PKI_DIR)/front-proxy-ca $(CONF_DIR)/front-proxy-ca.csr.conf
	openssl req -new -config $(CONF_DIR)/front-proxy-ca.csr.conf -out $(PKI_DIR)/root-ca/csr/front-proxy-ca.csr -keyout $(PKI_DIR)/front-proxy-ca/keys/front-proxy-ca.key

# front-proxy-ca cert
$(PKI_DIR)/front-proxy-ca/certs/front-proxy-ca.crt : $(PKI_DIR)/root-ca/csr/front-proxy-ca.csr $(CONF_DIR)/root-ca.conf
	openssl ca -batch -config $(CONF_DIR)/root-ca.conf -in $(PKI_DIR)/root-ca/csr/front-proxy-ca.csr -out $(PKI_DIR)/front-proxy-ca/certs/front-proxy-ca.crt

# front-proxy-client csr
$(PKI_DIR)/front-proxy-ca/keys/front-proxy-client.key $(PKI_DIR)/front-proxy-ca/csr/front-proxy-client.csr: $(PKI_DIR)/front-proxy-ca $(CONF_DIR)/front-proxy-client.csr.conf
	openssl req -new -config $(CONF_DIR)/front-proxy-client.csr.conf -out $(PKI_DIR)/front-proxy-ca/csr/front-proxy-client.csr -keyout $(PKI_DIR)/front-proxy-ca/keys/front-proxy-client.key

# front-proxy-client cert
$(PKI_DIR)/front-proxy-ca/certs/front-proxy-client.crt: $(PKI_DIR)/front-proxy-ca/csr/front-proxy-client.csr $(CONF_DIR)/front-proxy-ca.conf
	openssl ca -batch -config $(CONF_DIR)/front-proxy-ca.conf -in $(PKI_DIR)/front-proxy-ca/csr/front-proxy-client.csr -out $(PKI_DIR)/front-proxy-ca/certs/front-proxy-client.crt


clean:
	rm -fR $(PKI_DIR)
