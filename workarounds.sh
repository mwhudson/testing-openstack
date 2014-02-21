# workaround for https://bugs.launchpad.net/ubuntu/+source/netcf/+bug/1273719
# where libvirt (which uses netcf) commands like iface-* do not work correctly
# when a source-directory directive is present
echo "updating /etc/network/interfaces"
sed --in-place 's/source-directory/#source-directory/' /etc/network/interfaces

# Workaround for https://bugs.launchpad.net/ubuntu/+source/python-keystoneclient/+bug/1242992:
sudo apt-get -y remove python-keyring
sudo apt-get -y autoremove

# For some reason, mysql on Linaro images does not allow root login correctly
./fix-mysql-login-failures.sh
