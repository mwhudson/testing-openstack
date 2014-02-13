#~/bin/bash

source devstack/openrc

DESIRED_FLAVOR=m1.micro
DESIRED_IMAGE_PREFIX=saucy-server
INSTANCE_NAME=linaro-test

function check_instance_running() {
  state=`nova list | awk '/'${INSTANCE_NAME}'/{print $6}'`

  if [ "${state}" == "ACTIVE" ]; then
    echo "RUNNING"
  else
    echo "NOT_RUNNING"
  fi
}


running=`check_instance_running`
if [[ "${running}" == "RUNNING" ]] ; then
  echo "FAIL: Instance already running - delete the instance first"
  exit 1
fi

echo "Booting new instance: image:${image_uuid}, flavor:${flavor_id}"

image_uuid=`glance image-list | awk '/'${DESIRED_IMAGE_PREFIX}'.*ami/{print $2}'`
flavor_id=`nova flavor-list | awk '/'${DESIRED_FLAVOR}'/{print $2}'`

instance_id=`nova boot ${INSTANCE_NAME} --image "${image_uuid}" --flavor ${flavor_id} | awk '/\| id /{print $4}'`

# check to see if the image has booted... loop until 'nova list' shows it has started

running=NOT_RUNNING
counter=30
while [[ "${running}" != "RUNNING" && ${counter} -gt 0 ]] ; do
   echo "  Waiting for guest instance to report running (${counter})"
   sleep 15
   running=`check_instance_running`
   let counter-=1
done

if [[ "${running}" == "RUNNING" ]] ; then
   echo "Guest instance is running"
else
   echo "FAIL: Guest is still not running"
   exit 1
fi

# now, start checking the console log to see when cloud-init completes

result=
counter=30
while [[ "${result}" == "" && ${counter} -gt 0 ]] ; do
   echo "  Waiting for guest instance to finish booting (${counter})"
   sleep 15
   result=`nova console-log ${INSTANCE_NAME} | grep '^Cloud-init.*finished'`
   let counter-=1
done

if [[ "${running}" == "RUNNING" ]] ; then
   echo "PASS: Guest instance has booted"
else
   echo "FAIL: Guest is still not booted"
   exit 1
fi

