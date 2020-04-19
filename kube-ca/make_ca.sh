#!/bin/bash

# Validate arguments
if [[ $# -eq 0 ]] ; then
    echo 'Usage: $0 <ca-name>'
    exit 1 
fi

# Parse PKI directory
PKI_DIR=$1

# Parse CA name
CA=$2

# Create directories
mkdir -p $PKI_DIR/$CA/{keys,db,crl,newcerts,certs,csr}
chmod 700 $PKI_DIR/$CA/keys

# Create database
cp /dev/null $PKI_DIR/$CA/db/$CA.db
cp /dev/null $PKI_DIR/$CA/db/$CA.db.attr
echo 01 > $PKI_DIR/$CA/db/$CA.crt.srl
echo 01 > $PKI_DIR/$CA/db/$CA.crl.srl

