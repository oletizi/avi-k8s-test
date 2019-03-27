#!/bin/bash

mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/.." && pwd )
ansible=$( cd "${root}/ansible" && pwd )

. ${mydir}/config.sh
. ${AVI_DEMO_CONFIG}

default_avi_password=$1

playbook=${HOME}/devops/ansible/gcp/controller_kcloud.yaml
#playbook=${ansible}/controller_kcloud.yaml

cmd="ansible-playbook -i ${AVI_DEMO_ANSIBLE_HOSTS_FILE}  ${playbook} -vvv -e \"password=${AVI_DEMO_CONTROLLER_PASSWORD} controller_ip=${AVI_DEMO_CONTROLLER_IP} avi_config_state=present default_avi_password=1CoolNewPassword kube_master_node=${AVI_DEMO_MASTER_IP} project_name=${AVI_DEMO_PROJECT_NAME}\""
echo "Executing ${cmd}"
eval ${cmd}
