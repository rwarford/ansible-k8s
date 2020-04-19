#!/bin/bash

TOKENID=$(< /dev/urandom tr -dc a-z0-9 | head -c${1:-6};echo;)
SECRET=$(< /dev/urandom tr -dc a-z0-9 | head -c${1:-16};echo;)
EXPIRATION=$(date --date '1hour' --utc "+%FT%T.%N"| sed -r 's/\.[[:digit:]]{9}$/Z/')

sed  "s/TOKENID/$TOKENID/;s/SECRET/$SECRET/;s/EXPIRATION/$EXPIRATION/" bootstrap.secret.yaml.template | kubectl --kubeconfig=/etc/kubernetes/admin.conf apply -f - >/dev/null

printf "$TOKENID.$SECRET"
