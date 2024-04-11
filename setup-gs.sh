#!/usr/bin/env bash

HOST=pihole2

set -x

curl -fsSL https://raw.githubusercontent.com/vmstan/gs-install/main/gs-install.sh -o gs-install.sh

incus file push ./gs-install.sh $HOST/tmp/gs-install.sh -pv --mode 755

incus exec $HOST -- bash -c /tmp/gs-install.sh
