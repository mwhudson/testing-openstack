#!/bin/bash
NOVA_CONF=/etc/nova/nova.conf

# keep track of the devstack directory
TOP_DIR=$(cd $(dirname "$0") && pwd)

# import common functions
source $TOP_DIR/functions

# Use openrc + stackrc + localrc for settings
source $TOP_DIR/stackrc

# import nova functions
source $TOP_DIR/lib/nova

# Get OpenStack admin auth
source $TOP_DIR/openrc admin admin

# create SSH key if not present
echo "Create Linaro SSH keypair"
KEY_NAME=LinaroKey
KEY_FILE=`ls *.pub`
if [[ -z $(nova keypair-list | grep $KEYPAIR_NAME) ]]; then
    nova keypair-add --pub_key ${KEY_FILE} ${KEY_NAME}
fi

# set property of image to run as virt model
echo "Update image with properties required to run as a mach-virt guest"
IMAGE_UUID=`glance image-list | awk '/linaro.*ami/{print $2}'`
glance image-update $IMAGE_UUID --property hw_machine_type=virt
glance image-update $IMAGE_UUID --property hw_cdrom_bus=virtio
glance image-update $IMAGE_UUID --property os_command_line='root=/dev/vdb rw rootwait console=ttyAMA0'

echo "Host List:"
nova host-list
