#!/bin/bash

# store off the current directory and create a temp directory
export TESTDIR=`pwd`
export TMPDIR=${TESTDIR}/tmp
mkdir -p ${TMPDIR}

# write out Linaro tools PPA configuration file
distro=`lsb_release -s -c`
sudo cat > /etc/apt/sources.list.d/linaro-overlay.list << EOF
deb http://repo.linaro.org/ubuntu/linaro-overlay ${distro} main
deb-src http://repo.linaro.org/ubuntu/linaro-overlay ${distro} main
EOF

# import repo key
wget http://repo.linaro.org/ubuntu/linarorepo.key
sudo apt-key add linarorepo.key
rm linarorepo.key
sudo apt-get update

# flash-kernel must be uninstalled first to prevent a blocking prompt from update-initramfs!
sudo apt-get -y remove flash-kernel

# install some dependencies
sudo apt-get -y install qemu-system libvirt-bin python-libvirt

# get devstack
git clone git://git.linaro.org/people/clark.laughlin/devstack.git
cp local.sh ./devstack
cp local.conf ./devstack
cp boot-test-image.sh ./devstack

# configure workarounds for linaro images
./workarounds.sh

# setup devstack
cd ./devstack
./stack.sh | tee install.log
cd ${TESTDIR}

