#!/bin/bash
mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/.." && pwd )
ansible=$( cd "${root}/ansible" && pwd )
. ${mydir}/config.sh

assert_journal "04"


if [[ -f ${AVI_DEMO_CONFIG} ]]; then
  rm ${AVI_DEMO_CONFIG}
fi

function next_subnet() {
  subnet=$1
  echo $(echo "${subnet}" | awk -F. '{ print $1"."$2"."$3+1"."$4 }' )
}

function subnet_octet() {
  subnet=$1
  octet=$2
  echo $(echo "${subnet}" | awk -v octet=${octet} -F. '{ print $1"."$2"."$3"."octet }' )
}

# gather ssh keys for gcloud compute resources and add them to ssh config
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

# Determine non-colliding subnets for EW & NS networks
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


# Set up Ansible sandbox
sandbox="${root}/tmp/ansible"
if [[ ! -d ${sandbox} ]]; then
  mkdir -p ${sandbox}
  assert_success $? "Unable to create temporary directory for ansible sandbox: ${sandbox}"
fi
cp \
  "${ansible}/avi_config.yml" \
  "${ansible}/controller_install.yml" \
  "${ansible}/controller_kcloud.yml" \
  "${ansible}/hosts.yml" \
  "${sandbox}"
assert_success $? "Unable to copy ansible files to sandbox!"

ew_start=$( subnet_octet "${ew_subnet}" 2 )
ew_end=$( subnet_octet "${ew_subnet}" 254 )

ns_start=$( subnet_octet "${ns_subnet}" 2 )
ns_end=$( subnet_octet "${ns_subnet}" 254 )

avi_creds="${sandbox}/avi_creds.yml"
cmd="m4
  -D __EW_SUBNET__=${ew_subnet} \
  -D __EW_SUBNET_START__=${ew_start} \
  -D __EW_SUBNET_END__=${ew_end} \
  -D __NS_SUBNET__=${ns_subnet} \
  -D __NS_SUBNET_START__=${ns_start} \
  -D __NS_SUBNET_END__=${ns_end} \
  -D __PROJECT_NAME__=${project_name} \
  -D __MASTER_NODE__=${master_ip} \
  ${ansible}/avi_creds.yml.m4"

${cmd} > "${avi_creds}"

echo "Ansible configuration:"
cat "${avi_creds}"

controller_hostname="${AVI_DEMO_CONTROLLER_INSTANCE_NAME}.${AVI_DEMO_CONTROLLER_INSTANCE_ZONE}.${AVI_DEMO_PROJECT}"
# write transient host config to sandbox hosts file
tee -a "${sandbox}/hosts.yml" <<EOF
[bm]
${master_ip}

[controllers]
${controller_hostname} ansible_connection=ssh
EOF

# Write transient config to configuration file
# XXX: TODO: This could be prettier; maybe use m4
echo "Writing transient configuration to config file: ${AVI_DEMO_CONFIG}..."
tee ${AVI_DEMO_CONFIG} <<EOF
export AVI_DEMO_MASTER_IP=${master_ip}
export AVI_DEMO_CONTROLLER_PASSWORD='${password}'
export AVI_DEMO_CONTROLLER_IP=${controller_ip}
export AVI_DEMO_CONTROLLER_HOSTNAME=${controller_hostname}
export AVI_DEMO_PROJECT_NAME=${project_name}
export AVI_DEMO_EW_SUBNET=${ew_subnet}
export AVI_DEMO_NS_SUBNET=${ns_subnet}
EOF

journal "05"

# TODO: Cleanup

#echo "export AVI_DEMO_MASTER_IP=${master_ip}" > ${AVI_DEMO_CONFIG}
#echo "export AVI_DEMO_CONTROLLER_PASSWORD='${password}'" >> ${AVI_DEMO_CONFIG}
#echo "export AVI_DEMO_CONTROLLER_IP=${controller_ip}" >> ${AVI_DEMO_CONFIG}
#echo "export AVI_DEMO_CONTROLLER_HOSTNAME=${controller_hostname}" >> ${AVI_DEMO_CONFIG}
#echo "export AVI_DEMO_PROJECT_NAME=${project_name}" >> ${AVI_DEMO_CONFIG}
#echo "export AVI_DEMO_EW_SUBNET=${ew_subnet}" >> ${AVI_DEMO_CONFIG}
#echo "export AVI_DEMO_NS_SUBNET=${ns_subnet}" >> ${AVI_DEMO_CONFIG}
#echo "Config file contents:"
#cat ${AVI_DEMO_CONFIG}

