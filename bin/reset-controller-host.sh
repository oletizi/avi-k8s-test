#!/bin/bash

mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/.." && pwd )
bin=$( cd "${root}/bin" && pwd )
ansible=$( cd "${root}/ansible" && pwd )

. ${bin}/config.sh
. ${AVI_DEMO_CONFIG}

controller=${AVI_DEMO_CONTROLLER_HOSTNAME}

if [[ "" == ${controller}  ]]; then
    echo "Please specify controller hostname or IP address."
    exit 1
fi

cmd="ssh ${controller} sudo systemctl stop avicontroller.service"
echo "Executing ${cmd}"
${cmd}

cmd="ssh ${controller} sudo systemctl disable avicontroller.service"
echo "Executing ${cmd}"
${cmd}

cmd="ssh ${controller} sudo rm /etc/systemd/system/avicontroller.service"
echo "Executing ${cmd}"
${cmd}

cmd="ssh ${controller} sudo systemctl daemon-reload"
echo "Executing ${cmd}"
${cmd}

cmd="ssh ${controller} sudo systemctl reset-failed"
echo "Executing ${cmd}"
${cmd}

