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

nova host-list
nova image-list
nova keypair-list
nova flavor-list
nova network-list

glance image-list

cinder service-list

