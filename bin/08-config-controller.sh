#!/bin/bash

mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/.." && pwd )
ansible=$( cd "${root}/ansible" && pwd )

. ${mydir}/config.sh
. ${AVI_DEMO_CONFIG}

default_avi_password=$1

#playbook=${HOME}/devops/ansible/gcp/controller_kcloud.yaml
playbook=${ansible}/k8s_cloud_gcp.yaml

# TODO: Figure out password stuff
cmd="ansible-playbook -i ${AVI_DEMO_ANSIBLE_HOSTS_FILE}  ${playbook} -vvv -e \"password=CoolNewPassword1 controller_ip=${AVI_DEMO_CONTROLLER_IP} avi_config_state=present default_avi_password=${default_avi_password}\""
echo "Executing ${cmd}"
eval ${cmd}
