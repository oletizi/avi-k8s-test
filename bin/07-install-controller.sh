#!/bin/bash

mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/.." && pwd )
ansible=$( cd "${root}/ansible" && pwd )

. ${mydir}/config.sh
. ${AVI_DEMO_CONFIG}

tmp_hosts=${AVI_DEMO_ANSIBLE_HOSTS_FILE}
cp ${ansible}/hosts.yml ${tmp_hosts}

# write transient host config to temporary hosts file
tee ${tmp_hosts} <<EOF
[bm]
${AVI_DEMO_MASTER_IP}

[controllers]
${AVI_DEMO_CONTROLLER_HOSTNAME} ansible_connection=ssh
EOF

echo "Ansible hosts file contents:"
cat ${tmp_hosts}

cmd="ansible-playbook -i ${tmp_hosts} ${ansible}/controller.yml"
echo "Executing ansible-playbook to install the Avi controller: ${cmd}"
${cmd}
