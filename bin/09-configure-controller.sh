#!/bin/bash

mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/.." && pwd )
ansible=$( cd "${root}/ansible" && pwd )

. ${mydir}/config.sh
. ${AVI_DEMO_CONFIG}

assert_journal "08"

default_avi_password=$1

playbook_src=${ansible}
playbook_name="controller_kcloud.yml"
sandbox="${root}/tmp/ansible"
playbook="${sandbox}/${playbook_name}"

if [[ ! -f ${playbook} ]]; then
  echo "Playbook does not exist: ${playbook}!"
fi

# poll controller until it's ready
controller_starting=1

# TODO: The controller returns 200 for a while before it's ready. Need to determine definitive check
echo "Waiting for Avi Controller to start. This may take a few minutes..."
while [[ ${controller_starting} == 1 ]]; do
  status_code=$(curl -k -s -o /dev/null -w "%{http_code}" https://${AVI_DEMO_CONTROLLER_IP}/)
  if [[ ${status_code} == 200 ]]; then
    controller_starting=0
    echo "Controller has started."
  else
    echo "Controller is still starting..."
    sleep 5
  fi
done

# TODO: Since there's already an m4 transformation happening, it's probably cleaner to use m4 here, too, instead of environment variables
cmd="ansible-playbook -i ${sandbox}/hosts.yml  ${playbook} -vvv -e \"password=${AVI_DEMO_CONTROLLER_PASSWORD} controller_ip=${AVI_DEMO_CONTROLLER_IP} avi_config_state=present default_avi_password=1CoolNewPassword kube_master_node=${AVI_DEMO_MASTER_IP} project_name=${AVI_DEMO_PROJECT_NAME}\""
echo "Executing ${cmd}"
eval ${cmd}
assert_success $? "Unable to configure Avi Controller. Please try again."

journal "09"
