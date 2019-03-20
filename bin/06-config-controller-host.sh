#!/bin/bash
mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/.." && pwd )

. ${mydir}/config.sh
. ${AVI_DEMO_CONFIG}

controller=${AVI_DEMO_CONTROLLER_HOSTNAME}

# install Docker CE

cmd="ssh ${controller} sudo apt-get remove docker docker-engine docker.io containerd runc"
echo "Executing ${cmd}"
${cmd}

cmd="ssh ${controller} sudo apt-get update"
echo "Executing ${cmd}"
${cmd}

cmd="ssh ${controller} sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common python"
echo "Executing ${cmd}"
${cmd}

cmd="ssh ${controller} curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -"
echo "Executing ${cmd}"
${cmd}

cmd="ssh ${controller} sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu \$(lsb_release -cs) stable\""
echo "Executing ${cmd}"
${cmd}

cmd="ssh ${controller} sudo apt-get update"
echo "Executing ${cmd}"
${cmd}

cmd="ssh ${controller} sudo apt-get install -y docker-ce docker-ce-cli containerd.io"
echo "Executing ${cmd}"
${cmd}
