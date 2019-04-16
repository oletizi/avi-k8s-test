#!/bin/bash

mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/.." && pwd )
ansible=$( cd "${root}/ansible" && pwd )

. ${mydir}/config.sh
. ${AVI_DEMO_CONFIG}

assert_journal "08"

default_avi_password=$1

playbook=${HOME}/devops/ansible/gcp/controller_kcloud.yaml
#playbook=${ansible}/controller_kcloud.yaml

# poll controller until it's ready
controller_starting=1

echo "Waiting for Avi Controller to start. This may take a few minutes..."
while [[ ${controller_starting} == 1 ]]; do
  status_code=$(curl -k -s -o /dev/null -w "%{http_code}" https://${AVI_DEMO_CONTROLLER_IP}/)
  if [[ ${status_code} == 301 ]]; then
    controller_starting=0
    echo "Controller has started."
  else
    echo "Controller is still starting..."
    sleep 5
  fi
done

cmd="ansible-playbook -i ${AVI_DEMO_ANSIBLE_HOSTS_FILE}  ${playbook} -vvv -e \"password=${AVI_DEMO_CONTROLLER_PASSWORD} controller_ip=${AVI_DEMO_CONTROLLER_IP} avi_config_state=present default_avi_password=1CoolNewPassword kube_master_node=${AVI_DEMO_MASTER_IP} project_name=${AVI_DEMO_PROJECT_NAME}\""
echo "Executing ${cmd}"
eval ${cmd}
assert_success $? "Unable to configure Avi Controller. Please try again."

journal "09"
