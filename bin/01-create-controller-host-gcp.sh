#!/bin/bash


#--image=ubuntu-1804-bionic-v20190307 --image-project=ubuntu-os-cloud
#--image=centos-7-v20190312 --image-project=centos-cloud

image="ubuntu-1804-bionic-v20190307"
image_project="ubuntu-os-cloud"

#echo -n "orion:" > /tmp/id_rsa.pub
#cat ~/.ssh/id_rsa.pub >> /tmp/id_rsa.pub
#gcloud compute project-info add-metadata --metadata-from-file ssh-keys=/tmp/id_rsa.pub
#rm /tmp/id_rsa.pub

gcloud compute \
  --project=avistio-gtm \
  instances create controller \
  --zone=us-central1-a \
  --machine-type=n1-standard-4 \
  --subnet=default \
  --address=35.193.2.159 \
  --network-tier=PREMIUM \
  --maintenance-policy=MIGRATE \
  --service-account=316441934044-compute@developer.gserviceaccount.com \
  --scopes=https://www.googleapis.com/auth/compute,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/trace.append,https://www.googleapis.com/auth/devstorage.read_only \
  --tags=avi-se-dp-heartbeat,http-server,https-server \
  --image=${image} \
  --image-project=${image_project} \
  --boot-disk-size=80GB \
  --boot-disk-type=pd-standard \
  --boot-disk-device-name=controller

gcloud compute --project=avistio-gtm firewall-rules create avi-allow-http --direction=INGRESS --priority=1000 --network=avi --action=ALLOW --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server

gcloud compute --project=avistio-gtm firewall-rules create avi-allow-https --direction=INGRESS --priority=1000 --network=avi --action=ALLOW --rules=tcp:443 --source-ranges=0.0.0.0/0 --target-tags=https-server
