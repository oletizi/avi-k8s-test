#!/bin/bash

mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/.." && pwd )
bin=$( cd "${root}/bin" && pwd )
ansible=$( cd "${root}/ansible" && pwd )

. ${bin}/config.sh

ansible-playbook ${ansible}/k8s_cloud_gcp.yaml -vvv -e "password=CoolNewPassword1 controller_ip=${CONTROLLER} avi_config_state=present default_avi_password=iHaveNoIdea"
