#!/bin/bash

mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/.." && pwd )
ansible=$( cd "${root}/ansible" && pwd )
sandbox="${root}/tmp/ansible"

. ${mydir}/config.sh
. ${AVI_DEMO_CONFIG}

assert_journal "07"

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


hosts_file="${sandbox}/hosts.yml"
playbook="${sandbox}/controller_install.yml"

echo "Ansible hosts file contents:"
cat "${hosts_file}"

cmd="ansible-playbook -i ${hosts_file} ${playbook}"
echo "Executing ansible-playbook to install the Avi Controller: ${cmd}"
${cmd}
assert_success $? "Unable to install Avi Controller. Please try again."

journal "08"