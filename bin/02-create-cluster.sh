#!/bin/bash
mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/.." && pwd )

. ${mydir}/config.sh

echo
echo "Please ensure that Google Kubernetes Engine is enabled for the current project."
echo "If you haven't done so, please visit the Google Cloud Console:"
echo
echo "   https://console.cloud.google.com/projectselector/kubernetes"
echo
read  -p "Is Google Kubernetes Engine enabled for this project? [y|N]: " input
echo
if [[ ${input} != "y" ]]; then
    echo "We can't proceed until Google Kubernetes Engine is enabled. Please resume the tutorial after you've done so."
    exit
fi
   
echo
echo "Creating GKE cluster:"
echo "  name        : ${AVI_DEMO_CLUSTER_NAME}"
echo "  machine type: ${AVI_DEMO_NODE_MACHINE_TYPE}"
echo "  node count  : ${AVI_DEMO_NODE_COUNT}"
echo "  zone        : ${AVI_DEMO_CLUSTER_ZONE}"
echo
echo "This may take a minute or so..."

cmd="gcloud container clusters create ${AVI_DEMO_CLUSTER_NAME} --zone=${AVI_DEMO_CLUSTER_ZONE} --machine-type=${AVI_DEMO_NODE_MACHINE_TYPE} --num-nodes=${AVI_DEMO_NODE_COUNT}"
echo ${cmd}
eval ${cmd}

