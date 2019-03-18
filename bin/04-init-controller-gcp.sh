#!/bin/bash

mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/.." && pwd )
bin=$( cd "${root}/bin" && pwd )
ansible=$( cd "${root}/ansible" && pwd )

. ${bin}/config.sh

cmd="ansible-playbook ${ansible}/controller_kcloud.yaml -vvv -e \"password=CoolNewPassword1 controller_ip=${CONTROLLER_IP} avi_config_state=present default_avi_password=iHaveNoIdea\""
echo "Executing ${cmd}"
eval ${cmd}
