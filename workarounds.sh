# workaround for https://bugs.launchpad.net/ubuntu/+source/netcf/+bug/1273719
# where libvirt (which uses netcf) commands like iface-* do not work correctly
# when a source-directory directive is present
echo "updating /etc/network/interfaces"
sed --in-place 's/source-directory/#source-directory/' /etc/network/interfaces

# Workaround for https://bugs.launchpad.net/ubuntu/+source/python-keystoneclient/+bug/1242992:
sudo apt-get -y remove python-keyring
sudo apt-get -y autoremove

# uninstall mysql so devstack can reinstall it
sudo apt-get -y remove mysql-server
mysql_data_dir=/var/lib/mysql
if [ -d "${mysql_data_dir}" ]; then
   sudo rm -rf ${mysql_data_dir}
fi

# For some reason, mysql on Linaro images does not allow root login correctly
#bash -x ./fix-mysql-login-failures.sh
