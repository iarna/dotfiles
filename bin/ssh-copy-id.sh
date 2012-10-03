#!/bin/sh
HOST=$1
if [ -z "$HOST" ]; then
	echo "Form: $0 hostname"
	exit 1
fi
KEY=$(find ~/.ssh/id_rsa.pub ~/.ssh/id_dsa.pub | head -1)
if [ -z "$KEY" ]; then
	echo "No key detected, generating..."
	ssh-keygen && exec $0 $@
	exit 1
else
	echo "Installing $KEY on $HOST"
fi

cat $KEY | ssh $HOST 'test -d .ssh || mkdir -m 0700 .ssh ; cat >> ~/.ssh/authorized_keys'
