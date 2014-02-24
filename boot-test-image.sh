DESIRED_FLAVOR=m1.linarotest
DESIRED_IMAGE_PREFIX=saucy-server

source ./openrc

image_uuid=`glance image-list | awk '/'${DESIRED_IMAGE_PREFIX}'.*ami/{print $2}'`
flavor_id=`nova flavor-list | awk '/'${DESIRED_FLAVOR}'/{print $2}'`
keypair=LinaroKey

if [[ -z `nova secgroup-list-rules default | grep tcp | grep 22` ]] ; then
    nova secgroup-add-rule default tcp 22 22 0.0.0.0/0
fi

if [[ -z `nova secgroup-list-rules default | grep icmp | grep -1` ]] ; then
    nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0
fi

nova boot linaro-test --image "${image_uuid}" --flavor ${flavor_id} --key_name ${keypair} --security_group default

