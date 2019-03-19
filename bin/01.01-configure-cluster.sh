#!/usr/bin/env bash

mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/.." && pwd )

. ${mydir}/config.sh

# store the default service account secret to a file
echo "Fetching token for service account ${AVI_DEMO_SERVICE_ACCOUNT_NAME} and storing in ${AVI_DEMO_SERVICE_TOKEN_FILE}..."

kubectl get secret \
  $(kubectl get serviceaccounts ${AVI_DEMO_SERVICE_ACCOUNT_NAME} -o 'jsonpath={.secrets[0].name}') \
  -o 'jsonpath={.data.token}' | base64 -D > ${AVI_DEMO_SERVICE_TOKEN_FILE}

echo "Binding cluster role to all service accounts:"
echo "  cluster role binding name: ${AVI_DEMO_SERVICE_CLUSTER_ROLE_BINDING_NAME}"
echo "  cluster role             : ${AVI_DEMO_SERVICE_CLUSTER_ROLE}"

# grant default service account god privileges (XXX: grant only what's needed)
kubectl create clusterrolebinding ${AVI_DEMO_SERVICE_CLUSTER_ROLE_BINDING_NAME} \
  --clusterrole=${AVI_DEMO_SERVICE_CLUSTER_ROLE} \
  --group=system:serviceaccounts
