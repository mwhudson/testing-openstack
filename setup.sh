#!/bin/bash

# store off the current directory and create a temp directory
export TESTDIR=`pwd`
export TMPDIR=${TESTDIR}/tmp
mkdir -p ${TMPDIR}

echo "CPU Information:"
lscpu

# install some dependencies
sudo apt-get -y install qemu-system libvirt-bin python-libvirt ntpdate

# set the time using NTP -- seems to be off on midway
sudo ntpdate ntp.ubuntu.com

# get devstack
### git clone git://git.linaro.org/people/clark.laughlin/devstack.git
git clone git://github.com/mwhudson/devstack.git -b arm64-trusty-icehouse

cp local.sh ./devstack
cp local.conf ./devstack
cp display-openstack-info.sh ./devstack
cp keypair_rsa.pub ./devstack

sudo modprobe nbd

# the temp directory created by LAVA needs to allow write access to everyone -- not just root
chmod 777 ${TMPDIR}

chown -R ubuntu:ubuntu ./devstack
cd ./devstack
export DEVSTACK_ROOT=`pwd`
su --login --shell "/bin/bash" ubuntu <<EOF
export PATH=/sbin:/usr/sbin:$PATH
env
cd ${DEVSTACK_ROOT}
./stack.sh
EOF
cd ${TESTDIR}
