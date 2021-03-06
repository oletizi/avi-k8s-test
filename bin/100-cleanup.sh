#!/bin/bash
mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/.." && pwd )

. ${mydir}/config.sh

echo "Cleaning up. This may take a few minutes..."

if [[ "" != $(gcloud container clusters list | grep ${AVI_DEMO_CLUSTER_NAME}) ]]; then
    echo "Deleting cluster ${AVI_DEMO_CLUSTER_NAME}..."
    echo
    gcloud --quiet container clusters delete --zone=${AVI_DEMO_CONTROLLER_INSTANCE_ZONE} ${AVI_DEMO_CLUSTER_NAME}
fi

if [[ "" != $(gcloud compute instances list | grep ${AVI_DEMO_CONTROLLER_INSTANCE_NAME}) ]]; then
    echo
    echo "Deleting controller instance ${AVI_DEMO_CONTROLLER_INSTANCE_NAME}..."
    echo
    gcloud --quiet compute instances delete --zone=${AVI_DEMO_CONTROLLER_INSTANCE_ZONE} ${AVI_DEMO_CONTROLLER_INSTANCE_NAME}
fi

rm ${AVI_DEMO_JOURNAL}