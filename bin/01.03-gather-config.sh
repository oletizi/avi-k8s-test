#!/bin/bash
mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/.." && pwd )

. ${mydir}/config.sh

# gather ssh keys for gcloud compute resources and add them to ssh config
gcloud compute config-ssh

# TODO: Test with a non-static IP
echo "Fetching Avi controller host IP address..."
controller_ip=$(gcloud compute instances describe --zone=${AVI_DEMO_CONTROLLER_INSTANCE_ZONE} ${AVI_DEMO_CONTROLLER_INSTANCE_NAME} --format=\"json\" | jq -r '.networkInterfaces[0].accessConfigs[0].natIP')
echo "Avi controller host IP address: ${controller_ip}"

echo "Fetching cluster master IP address..."
master_ip=$(gcloud container clusters describe --zone=${AVI_DEMO_CLUSTER_ZONE} --format="json" ${AVI_DEMO_CLUSTER_NAME} | jq -r .endpoint)
echo "Cluster master IP address: ${master_ip}"

# Write transient config to configuration file
echo "Writing transient configuration to config file: ${AVI_DEMO_CONFIG}..."
echo "export AVI_DEMO_MASTER_IP=${master_ip}" > ${AVI_DEMO_CONFIG}
echo "export AVI_DEMO_CONTROLLER_IP=${controller_ip}" >> ${AVI_DEMO_CONFIG}
#ssh controller.us-central1-a.avistio-gtm
echo "export AVI_DEMO_CONTROLLER_HOSTNAME=${AVI_DEMO_CONTROLLER_INSTANCE_NAME}.${AVI_DEMO_CONTROLLER_INSTANCE_ZONE}.${AVI_DEMO_PROJECT}" >> ${AVI_DEMO_CONFIG}
echo "Config file contents:"
cat ${AVI_DEMO_CONFIG}
