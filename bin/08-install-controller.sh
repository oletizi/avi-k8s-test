#!/bin/bash

mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/.." && pwd )
ansible=$( cd "${root}/ansible" && pwd )

. ${mydir}/config.sh
. ${AVI_DEMO_CONFIG}

assert_journal "07"

tmp_hosts=${AVI_DEMO_ANSIBLE_HOSTS_FILE}
cp ${ansible}/hosts.yml ${tmp_hosts}

# Patch the controller installation role to remove borken version check
# TODO: Remove this when the bug is fixed

check_file="${HOME}/.__ANSIBLE_ROLE_PATCHED"
if [[ ! -f ${check_file} ]]; then
  echo "Patching avicontroller role..."
  sed -i 's/when: ansible_version/#when: ansible_version/' ${HOME}/.ansible/roles/avinetworks.avicontroller/handlers/main.yml
  touch ${check_file}
else
  echo "Avicontroller role is already patched."
fi

# write transient host config to temporary hosts file
tee ${tmp_hosts} <<EOF
[bm]
${AVI_DEMO_MASTER_IP}

[controllers]
${AVI_DEMO_CONTROLLER_HOSTNAME} ansible_connection=ssh
EOF

echo "Ansible hosts file contents:"
cat ${tmp_hosts}

cmd="ansible-playbook -i ${tmp_hosts} ${ansible}/controller_install.yml"
echo "Executing ansible-playbook to install the Avi Controller: ${cmd}"
${cmd}
assert_success $? "Unable to install Avi Controller. Please try again."

journal "08"