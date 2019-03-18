#!/bin/bash

mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/.." && pwd )
bindir=$( cd "${root}/bin" && pwd )

. ${bindir}/config.sh

token=$(cat ~/.kube_service_token)
api_path="/api/v1/namespaces"
cmd="curl -k  -H 'Authorization: Bearer ${token}' https://${MASTER_IP}${api_path}"
echo "Executing ${cmd}"
eval ${cmd}
