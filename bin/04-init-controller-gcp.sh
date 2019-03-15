#!/bin/bash

mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/.." && pwd )
ansible=$( cd "${root}/ansible" && pwd )

ansible-playbook ${ansible}/k8s_cloud_gcp.yaml -vvv -e "password=CoolNewPassword1 controller_ip=35.193.2.159 avi_config_state=present default_avi_password=iHaveNoIdea"
