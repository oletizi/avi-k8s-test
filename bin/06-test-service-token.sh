#!/bin/bash

mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/.." && pwd )
bindir=$( cd "${root}/bin" && pwd )

. ${bindir}/config.sh
assert_journal "05"

. ${AVI_DEMO_CONFIG}

# TODO: fail if unauthorized

token=$(cat ~/.kube_service_token)
api_path="/api/v1/namespaces"
cmd="curl -k  -H 'Authorization: Bearer ${token}' https://${AVI_DEMO_MASTER_IP}${api_path}"
echo "Executing ${cmd}"
eval ${cmd}

journal "06"