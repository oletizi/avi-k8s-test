#!/bin/bash

mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/.." && pwd )
ansible=$( cd "${root}/ansible" && pwd )

token=$(cat ~/.kube_service_token)
api_path="/api/v1/namespaces"
cmd="curl -k  -H 'Authorization: Bearer ${token}' https://35.226.173.104${api_path}"
echo "Executing ${cmd}"
eval ${cmd}
