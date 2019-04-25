#!/bin/bash

mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/.." && pwd )
ansible=$( cd "${root}/ansible" && pwd )

. ${mydir}/config.sh
. ${AVI_DEMO_CONFIG}

assert_journal "08"

function subnet_octet() {
  subnet=$1
  octet=$2
  echo $(echo "${subnet}" | awk -v octet=${octet} -F. '{ print $1"."$2"."$3"."octet }' )
}

default_avi_password=$1

playbook_src=${HOME}/devops/ansible/gcp/
playbook_name="controller_kcloud.yaml"

sandbox=$(mktemp -d)
assert_success $? "Unable to create temporary directory for ansible sandbox!"

cd "${playbook_src}" \
  && cp \
    "${playbook_name}" \
    avi_config.yml \
    "${sandbox}"
assert_success $? "Unable to copy ansible files to sandbox!"
playbook="${sandbox}/${playbook_name}"

ew=${AVI_DEMO_EW_SUBNET}
ew_start=$( subnet_octet "${ew}" 1 )
ew_end=$( subnet_octet "${ew}" 255 )

ns=${AVI_DEMO_NS_SUBNET}
ns_start=$( subnet_octet "${ns}" 1 )
ns_end=$( subnet_octet "${ns}" 255 )

avi_creds="${sandbox}/avi_creds.yml"
cmd="m4
  -D __EW_SUBNET__=${ew} \
  -D __EW_SUBNET_START__=${ew_start} \
  -D __EW_SUBNET_END__=${ew_end} \
  -D __NS_SUBNET__=${ns} \
  -D __NS_SUBNET_START__=${ns_start} \
  -D __NS_SUBNET_END__=${ns_end} \
  -D __PROJECT_NAME__=${AVI_DEMO_PROJECT_NAME} \
  -D __MASTER_NODE__=${AVI_DEMO_MASTER_IP} \
  ${ansible}/avi_creds.yml.m4"

${cmd} > "${avi_creds}"

echo "Ansible configuration:"
cat "${avi_creds}"

# poll controller until it's ready
controller_starting=1

echo "Waiting for Avi Controller to start. This may take a few minutes..."
while [[ ${controller_starting} == 1 ]]; do
  status_code=$(curl -k -s -o /dev/null -w "%{http_code}" https://${AVI_DEMO_CONTROLLER_IP}/)
  if [[ ${status_code} == 200 ]]; then
    controller_starting=0
    echo "Controller has started."
  else
    echo "Controller is still starting..."
    sleep 5
  fi
done

# TODO: Since there's already an m4 transformation happening, it's probably cleaner to use m4 here, too, instead of environment variables
cmd="ansible-playbook -i ${AVI_DEMO_ANSIBLE_HOSTS_FILE}  ${playbook} -vvv -e \"password=${AVI_DEMO_CONTROLLER_PASSWORD} controller_ip=${AVI_DEMO_CONTROLLER_IP} avi_config_state=present default_avi_password=1CoolNewPassword kube_master_node=${AVI_DEMO_MASTER_IP} project_name=${AVI_DEMO_PROJECT_NAME}\""
echo "Executing ${cmd}"
eval ${cmd}
assert_success $? "Unable to configure Avi Controller. Please try again."

journal "09"
