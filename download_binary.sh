#!/bin/bash
set -ex
wget -qO- https://binaries.cockroachdb.com/cockroach-v20.1.6.linux-amd64.tgz | tar  xvz
cp cockroach-v20.1.6.linux-amd64/cockroach /usr/local/bin/ -f
mkdir /var/lib/cockroach
useradd cockroach
chown -R cockroach.cockroach /var/lib/cockroach

echo "Successfully fetched and installed"