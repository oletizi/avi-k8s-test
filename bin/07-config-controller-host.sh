#!/bin/bash
#
# XXX: TODO:
# - Remove the redundancy
# - add error checking, atomicity & idempotency
#
mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/.." && pwd )

. ${mydir}/config.sh
. ${AVI_DEMO_CONFIG}

assert_journal "06"

controller=${AVI_DEMO_CONTROLLER_HOSTNAME}
setup_dir="/opt/avi/controller/data/"

cmd="ssh ${controller} sudo apt-get remove docker docker-engine docker.io containerd runc"
echo "Executing ${cmd}"
${cmd}
assert_success $? "Failed to remove existing un-needed components"

cmd="ssh ${controller} sudo apt-get update"
echo "Executing ${cmd}"
${cmd}
assert_success $? "Failed to update apt"

cmd="ssh ${controller} sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common python"
echo "Executing ${cmd}"
${cmd}
assert_success $? "Failed to install packages"

cmd="ssh ${controller} curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -"
echo "Executing ${cmd}"
${cmd}
assert_success $? "Failed to add docker.com apt-key"


cmd="ssh ${controller} sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu \$(lsb_release -cs) stable\""
echo "Executing ${cmd}"
${cmd}
assert_success $? "Failed to add docker.com apt repository"

cmd="ssh ${controller} sudo apt-get update"
echo "Executing ${cmd}"
${cmd}
assert_success $? "Failed to update apt"

cmd="ssh ${controller} sudo apt-get install -y docker-ce docker-ce-cli containerd.io"
echo "Executing ${cmd}"
${cmd}
assert_success $? "Failed to install docker-ce"

cmd="ssh ${controller} sudo mkdir -p ${setup_dir}"
echo "Executing ${cmd}"
${cmd}
assert_success $? "Failed to create setup directory: ${setup_dir}"

cmd="scp ${root}/controller/setup.json ${controller}:/tmp/setup.json"
echo "Executing ${cmd}"
${cmd}
assert_success $? "Failed to copy setup.json to controller host"

cmd="ssh ${controller} sudo mv /tmp/setup.json ${setup_dir}"
echo "Executing ${cmd}"
${cmd}
assert_success $? "Failed to move setup.json to setup directory: ${setup_dir}"

journal "07"
