#!/bin/bash

distro=`lsb_release -s -c`
sudo cat > /etc/apt/sources.list.d/linaro-overlay.list << EOF
deb http://repo.linaro.org/ubuntu/linaro-overlay ${distro} main
deb-src http://repo.linaro.org/ubuntu/linaro-overlay ${distro} main
EOF

sudo cat >> /etc/network/interfaces << EOF

auto eth1
iface eth1 inet dhcp
EOF

wget http://repo.linaro.org/ubuntu/linarorepo.key
sudo apt-key add linarorepo.key
rm linarorepo.key
sudo apt-get update

# install some dependencies
sudo apt-get -y install qemu-system libvirt-bin python-libvirt bridge-utils pm-utils

# get devstack
git clone git://git.linaro.org/people/clark.laughlin/devstack.git
cp local.sh ./devstack
cp local.conf ./devstack
cp boot-test-image.sh ./devstack

pushd devstack
./stack.sh | tee install.log
popd



