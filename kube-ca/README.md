# Makefile for Kubernetes PKI

This generates all the certificates and keys necessary for a Kubernetes installation.

## Configuring the DN

Add a file called 'make.env' and cdd the following lines:
```
export CA_COUNTRY = <your country>
export CA_EMAIL = <your email address>
export CA_STATE = <your state>
export CA_LOCALITY = <your city>
```

## Building PKI

Set the following environment variables before running make:
* cluster_name
* master_name
* apiserver_ext_ip
* apiserver_int_ip

Example:
```bash
cluster_name="home-k8s" master_name="prodk8m01" apiserver_ext_ip="10.100.11.10" apiserver_int_ip="10.120.0.1" make
```

## Removing the PKI

Run `make clean` to remove all certificates and keys.

Example:
```bash
cluster_name="home-k8s" make clean
```
