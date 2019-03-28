#!/bin/bash
mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/.." && pwd )

. ${mydir}/config.sh

# gather ssh keys for gcloud compute resources and add them to ssh config
gcloud compute config-ssh

# Generate a password to use for the controller
password=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;)

# Get the controller host ip
echo "Fetching Avi controller host IP address..."
controller_ip=$(gcloud compute instances describe --zone=${AVI_DEMO_CONTROLLER_INSTANCE_ZONE} ${AVI_DEMO_CONTROLLER_INSTANCE_NAME} --format=\"json\" | jq -r '.networkInterfaces[0].accessConfigs[0].natIP')
echo "Avi controller host IP address: ${controller_ip}"

echo "Fetching cluster master IP address..."
master_ip=$(gcloud container clusters describe --zone=${AVI_DEMO_CLUSTER_ZONE} --format="json" ${AVI_DEMO_CLUSTER_NAME} | jq -r .endpoint)
echo "Cluster master IP address: ${master_ip}"

echo "Fetching current project name..."
project_name=$(gcloud config list --format 'value(core.project)' 2>/dev/null)
echo "Current project name: ${project_name}"

# Write transient config to configuration file
# XXX: This could be prettier
echo "Writing transient configuration to config file: ${AVI_DEMO_CONFIG}..."
echo "export AVI_DEMO_MASTER_IP=${master_ip}" > ${AVI_DEMO_CONFIG}
echo "export AVI_DEMO_CONTROLLER_PASSWORD='${password}'" >> ${AVI_DEMO_CONFIG}
echo "export AVI_DEMO_CONTROLLER_IP=${controller_ip}" >> ${AVI_DEMO_CONFIG}
echo "export AVI_DEMO_CONTROLLER_HOSTNAME=${AVI_DEMO_CONTROLLER_INSTANCE_NAME}.${AVI_DEMO_CONTROLLER_INSTANCE_ZONE}.${AVI_DEMO_PROJECT}" >> ${AVI_DEMO_CONFIG}
echo "export AVI_DEMO_PROJECT_NAME=${project_name}" >> ${AVI_DEMO_CONFIG}
echo "Config file contents:"
cat ${AVI_DEMO_CONFIG}
