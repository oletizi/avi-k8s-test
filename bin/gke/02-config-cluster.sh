#!/usr/bin/env bash

# store the default service account secret in ~/.kube_service_token
kubectl get secret \
  $(kubectl get serviceaccounts default -o 'jsonpath={.secrets[0].name}') \
  -o 'jsonpath={.data.token}' | base64 -D > ~/.kube_service_token

# grant default service account god privileges (XXX: grant only what's needed)
kubectl create clusterrolebinding serviceaccounts-cluster-admin \
  --clusterrole=cluster-admin \
    --group=system:serviceaccounts