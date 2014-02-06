distro=`lsb_release -s -c`
sudo cat > /etc/apt/sources.list.d/linaro-overlay.list << EOF
deb http://repo.linaro.org/ubuntu/linaro-overlay ${distro} main
deb-src http://repo.linaro.org/ubuntu/linaro-overlay ${distro} main
EOF

wget http://repo.linaro.org/ubuntu/linarorepo.key
sudo apt-key add linarorepo.key
sudo apt-get update

sudo apt-get -y install qemu-system libvirt-bin python-libvirt bridge-utils pm-utils

./stack.sh

