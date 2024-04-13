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

if [ -f ./pihole.key -a -f ./pihole.crt ]; then
incus file push ./99-ssl.conf $HOST/etc/lighttpd/conf-available/ -pv --mode 644
incus file push ./pihole.key $HOST/etc/lighttpd/ -pv --mode 600
incus file push ./pihole.crt $HOST/etc/lighttpd/ -pv --mode 644
incus file create --type=symlink $HOST/etc/lighttpd/conf-enabled/99-ssl.conf ../conf-available/99-ssl.conf
incus exec $HOST -- apt-get install lighttpd-mod-openssl

incus exec $HOST -- systemctl restart lighttpd.service
fi
