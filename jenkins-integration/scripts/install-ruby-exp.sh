#!/bin/bash

SSH='ssh -l root -o StrictHostKeyChecking=no'
LOCATION=$1
VERSION=$2
MASTER=$3

$SSH $MASTER "wget ${LOCATION} && tar xzf ${VERSION}.tar.gz"
$SSH $MASTER "cd ${VERSION} && ./setup.sh"
$SSH $MASTER "wget http://neptune.delivery.puppetlabs.net/build-tools/new-ruby-experiment/all_modules.tar.gz"
$SSH $MASTER "tar xzf all_modules.tar.gz -C /opt/puppet/share/puppet/modules"
$SSH $MASTER "mkdir -p /etc/puppetlabs/mcollective && echo 'fooobar fofofo' > /etc/puppetlabs/mcollective/credentials"

cat > auth.conf << EOF
path /
auth any
allow *
EOF

scp auth.conf root@${MASTER}:
$SSH $MASTER "mv -f auth.conf /etc/puppetlabs/puppet/auth.conf && /etc/init.d/pe-httpd restart"
