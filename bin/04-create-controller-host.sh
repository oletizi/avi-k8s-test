#!/bin/bash
mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/.." && pwd )

. ${mydir}/config.sh

network=default

# TODO: Add idempotency

cmd="gcloud compute \
  instances create ${AVI_DEMO_CONTROLLER_INSTANCE_NAME} \
  --zone=${AVI_DEMO_CONTROLLER_INSTANCE_ZONE} \
  --machine-type=${AVI_DEMO_CONTROLLER_INSTANCE_MACHINE_TYPE} \
  --subnet=${AVI_DEMO_CONTROLLER_INSTANCE_SUBNET} \
  --network-tier=PREMIUM \
  --maintenance-policy=MIGRATE \
  --scopes=https://www.googleapis.com/auth/compute,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/trace.append,https://www.googleapis.com/auth/devstorage.read_only \
  --tags=avi-se-dp-heartbeat,http-server,https-server \
  --image=${AVI_DEMO_CONTROLLER_INSTANCE_IMAGE} \
  --image-project=${AVI_DEMO_CONTROLLER_INSTANCE_IMAGE_PROJECT} \
  --boot-disk-size=${AVI_DEMO_CONTROLLER_INSTANCE_BOOT_DISK_SIZE} \
  --boot-disk-type=pd-standard \
  --boot-disk-device-name=controller"
echo "Creating controller instance. This may take a minute or so..."
echo ${cmd}
eval ${cmd}

## TODO: Set up appropriate firewall rules for controller

cmd="gcloud compute \
       firewall-rules create avi-allow-http \
       --direction=INGRESS \
       --priority=1000 \
       --network=${network} \
       --action=ALLOW \
       --rules=tcp:80 \
       --source-ranges=0.0.0.0/0 \
       --target-tags=http-server"
echo "Creating http ingress firewall rule for controller:"
echo ${cmd}
eval ${cmd}

cmd="gcloud compute \
       firewall-rules create avi-allow-https \
       --direction=INGRESS \
       --priority=1000 \
       --network=${network} \
       --action=ALLOW \
       --rules=tcp:443 \
       --source-ranges=0.0.0.0/0 \
       --target-tags=https-server"
echo "Creating https ingress firewall rule for controller:"
echo ${cmd}
eval ${cmd}

