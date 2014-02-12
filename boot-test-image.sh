DESIRED_FLAVOR=m1.micro
DESIRED_IMAGE_PREFIX=saucy-server

source ./openrc

image_uuid=`glance image-list | awk '/'${DESIRED_IMAGE_PREFIX}'.*ami/{print $2}'`
flavor_id=`nova flavor-list | awk '/'${DESIRED_FLAVOR}'/{print $2}'`

nova boot linaro-test --image "${image_uuid}" --flavor ${flavor_id}

