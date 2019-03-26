#!/usr/bin/env bash

# Demo config file for storing transient cluster and controller configuration
export AVI_DEMO_CONFIG="${HOME}/.avi-demo-config"

# XXX: gcloud may not be installed or configured properly yet
export AVI_DEMO_PROJECT=$(gcloud config get-value project)
export AVI_DEMO_ZONE="us-central1-a"


# GKE config
export AVI_DEMO_CLUSTER_NAME="avi-demo"
export AVI_DEMO_CLUSTER_ZONE=${AVI_DEMO_ZONE}
export AVI_DEMO_NODE_MACHINE_TYPE="n1-standard-2"
export AVI_DEMO_NODE_COUNT=3
export AVI_DEMO_SERVICE_ACCOUNT_NAME="default"
export AVI_DEMO_SERVICE_TOKEN_FILE="${HOME}/.kube_service_token"
export AVI_DEMO_SERVICE_CLUSTER_ROLE="cluster-admin"
export AVI_DEMO_SERVICE_CLUSTER_ROLE_BINDING_NAME="serviceaccounts-cluster-admin"

# Controller config
export AVI_DEMO_CONTROLLER_INSTANCE_NAME="avi-tutorial-controller"
export AVI_DEMO_CONTROLLER_INSTANCE_IMAGE="ubuntu-1804-bionic-v20190307"
export AVI_DEMO_CONTROLLER_INSTANCE_IMAGE_PROJECT="ubuntu-os-cloud"
export AVI_DEMO_CONTROLLER_INSTANCE_ZONE=${AVI_DEMO_ZONE}
export AVI_DEMO_CONTROLLER_INSTANCE_SUBNET="default"
export AVI_DEMO_CONTROLLER_INSTANCE_MACHINE_TYPE="n1-standard-4"
export AVI_DEMO_CONTROLLER_INSTANCE_BOOT_DISK_SIZE="80GB"

# Ansible config
export AVI_DEMO_ANSIBLE_HOSTS_FILE=/tmp/hosts.yml
export AVI_DEMO_ANSIBLE_PLAYBOOK_VERSION=18.2.1
