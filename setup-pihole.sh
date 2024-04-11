#!/usr/bin/env bash

HOST=${HOST:-pihole}

set -x

incus stop $HOST
incus delete $HOST

incus launch images:debian/12 $HOST

curl -fsSL https://install.pi-hole.net -o basic-install.sh

incus file push ./basic-install.sh $HOST/tmp/basic-install.sh -pv --mode 755

incus exec $HOST -- bash -c /tmp/basic-install.sh

incus exec $HOST -- pihole -a -p
