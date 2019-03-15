#!/bin/bash

mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/.." && pwd )
ansible=$( cd "${root}/ansible" && pwd )

cmd="ansible-playbook -i ${ansible}/hosts.yml ${ansible}/controller.yml"
echo "Executing ${cmd}"
${cmd}
