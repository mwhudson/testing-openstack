#!/bin/bash

# store off the current directory and create a temp directory
export TESTDIR=`pwd`
export TMPDIR=${TESTDIR}/tmp
mkdir -p ${TMPDIR}

echo "CPU Information:"
lscpu

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
sudo apt-get -y install qemu-system libvirt-bin python-libvirt ntpdate

# set the time using NTP -- seems to be off on midway
sudo sudo ntpdate ntp.ubuntu.com

# get devstack
git clone git://git.linaro.org/people/clark.laughlin/devstack.git
cp local.sh ./devstack
cp local.conf ./devstack
cp boot-test-image.sh ./devstack

# configure workarounds for linaro images
./workarounds.sh

# the temp directory created by LAVA needs to allow write access to everyone -- not just root
chmod 777 ${TMPDIR}

# create stack user
./devstack/tools/create-stack-user.sh

# setup devstack (run as 'stack' user)
chown -R stack:stack ./devstack
cd ./devstack
export DEVSTACK_ROOT=`pwd`
su --login --shell "/bin/bash" stack <<EOF
env
cd ${DEVSTACK_ROOT}
./stack.sh | tee install.log
EOF
cd ${TESTDIR}

