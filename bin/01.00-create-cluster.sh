#!/bin/bash
mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/.." && pwd )

. ${mydir}/config.sh

echo "Creating GKE cluster:"
echo "  name        : ${AVI_DEMO_CLUSTER_NAME}"
echo "  machine type: ${AVI_DEMO_NODE_MACHINE_TYPE}"
echo "  node count  : ${AVI_DEMO_NODE_COUNT}"

gcloud container clusters create ${AVI_DEMO_CLUSTER_NAME} --machine-type=${AVI_DEMO_NODE_MACHINE_TYPE} --num-nodes=${AVI_DEMO_NODE_COUNT}

