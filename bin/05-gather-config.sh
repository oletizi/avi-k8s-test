#!/bin/bash
mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/.." && pwd )

. ${mydir}/config.sh

assert_journal "04"

if [[ -f ${AVI_DEMO_CONFIG} ]]; then
  rm ${AVI_DEMO_CONFIG}
fi

function next_subnet() {
  subnet=$1
  echo $(echo "${subnet}" | awk -F. '{ print $1"."$2"."$3+1"."$4 }' )
}

# gather ssh keys for gcloud compute resources and add them to ssh config
#gcloud --quiet compute config-ssh
cmd="gcloud ${AVI_DEMO_GCLOUD_GLOBAL_PARAMS} compute config-ssh --force-key-file-overwrite"
echo "Gathering ssh configuration via gcloud: ${cmd}"
${cmd} > /dev/null

assert_success $? "Unable to configure ssh. Please try again."

# Generate a password to use for the controller
password=$(< /dev/urandom tr -dc _A-Z-a-z-0-9| head -c${1:-32};echo;)
assert_not_empty "Unable to generate password for Avi Controller. Please try again." ${password}

# Get the controller host ip
echo "Fetching Avi controller host IP address..."
controller_ip=$(gcloud ${AVI_DEMO_GCLOUD_GLOBAL_PARAMS} compute instances describe --zone=${AVI_DEMO_CONTROLLER_INSTANCE_ZONE} ${AVI_DEMO_CONTROLLER_INSTANCE_NAME} --format=\"json\" | jq -r '.networkInterfaces[0].accessConfigs[0].natIP')
assert_not_empty "Unable to determine the Controller IP address. Please try again." ${controller_ip}
echo "Avi controller host IP address: ${controller_ip}"

# Get IP address of the Kubernetes master node
echo "Fetching cluster master IP address..."
master_ip=$(gcloud ${AVI_DEMO_GCLOUD_GLOBAL_PARAMS} container clusters describe --zone=${AVI_DEMO_CLUSTER_ZONE} --format="json" ${AVI_DEMO_CLUSTER_NAME} | jq -r .endpoint)
assert_not_empty "Unable to determine the Kubernetes master node IP address. Please try again." ${master_ip}
echo "Cluster master IP address: ${master_ip}"

# Get the project name
echo "Fetching current project name..."
project_name=$(gcloud ${AVI_DEMO_GCLOUD_GLOBAL_PARAMS} config list --format 'value(core.project)' 2>/dev/null)
assert_not_empty "Unable to determine the gcloud project name. Please try again." ${project_name}
echo "Current project name: ${project_name}"

# Determine non-colliding subnets for EW && NS networks
echo "Determining NS and EW subnets..."
cmd="gcloud compute networks subnets list --filter=region:(${AVI_DEMO_REGION}) --network=default"
echo "Fetching existing subnets: ${cmd}"
existing_subnets=$( ${cmd} )
echo "Existing subnets:"
echo ${existing_subnets}

subnet="10.0.0.0"
ew_subnet=""
ns_subnet=""

# TODO:
#  - range-checking--subnet values can overflow
#  - error-checking--handle errors from sub-shells
while [[ ${ew_subnet} == "" || ${ns_subnet} == "" ]]; do
  while [[ $( echo "${existing_subnets}" | grep "${subnet}" ) != "" ]]; do
    echo "Subnet candidate ${subnet} collides with existing subnet. Choosing new candidate..."
    subnet=$( next_subnet "${subnet}" )
    echo "New subnet candidate: ${subnet}"
  done
  if [[ "${ew_subnet}" == "" ]]; then
    ew_subnet=${subnet}
    subnet=$( next_subnet "${subnet}" )
    echo "ew_subnet: ${ew_subnet}"
  else
    ns_subnet=${subnet}
    echo "ns_subnet: ${ns_subnet}"
  fi
done

# Write transient config to configuration file
# XXX: TODO: This could be prettier; maybe use m4
echo "Writing transient configuration to config file: ${AVI_DEMO_CONFIG}..."
echo "export AVI_DEMO_MASTER_IP=${master_ip}" > ${AVI_DEMO_CONFIG}
echo "export AVI_DEMO_CONTROLLER_PASSWORD='${password}'" >> ${AVI_DEMO_CONFIG}
echo "export AVI_DEMO_CONTROLLER_IP=${controller_ip}" >> ${AVI_DEMO_CONFIG}
echo "export AVI_DEMO_CONTROLLER_HOSTNAME=${AVI_DEMO_CONTROLLER_INSTANCE_NAME}.${AVI_DEMO_CONTROLLER_INSTANCE_ZONE}.${AVI_DEMO_PROJECT}" >> ${AVI_DEMO_CONFIG}
echo "export AVI_DEMO_PROJECT_NAME=${project_name}" >> ${AVI_DEMO_CONFIG}
echo "export AVI_DEMO_EW_SUBNET=${ew_subnet}" >> ${AVI_DEMO_CONFIG}
echo "export AVI_DEMO_NS_SUBNET=${ns_subnet}" >> ${AVI_DEMO_CONFIG}
echo "Config file contents:"
cat ${AVI_DEMO_CONFIG}

journal "05"
