# workaround for https://bugs.launchpad.net/ubuntu/+source/netcf/+bug/1273719
# where libvirt (which uses netcf) commands like iface-* do not work correctly
# when a source-directory directive is present
echo "updating /etc/network/interfaces"
sed --in-place 's/source-directory/#source-directory/' /etc/network/interfaces
