# Testing for Avi in Kubernetes

## Description

A collection of ansible configuration files and bash scripts used to test setting up Avi Vantage for use in
front of a Kubernetes cluster.

## Procedure

### Prepare an Ansible configuration host
1. Install docker

1. Start the configuration container: 
  
    ``docker/localhost/run.sh`` 

1. Log into the configuration container: 
  
    ``docker exec -it avi-k8s-test-localhost bash``

1. From the configuration container, install the gcloud CLI:
  
    ``/home/ubuntu/avi-k8s-test/bin/00-install-gcloud.sh``

   Follow the directions to login to your gcloud account and set your default project and zone

1. From the configuration container, create the test Kubernetes cluster:
  
    ``/home/ubuntu/avi-k8s-test/bin/gke/02-config-cluster.sh``

1. Create a Google compute instance to serve as host for the Avi controller:
  
    ``/home/ubuntu/avi-k8s-test/bin/01-create-controller-host-gcp.sh``

1. Update ssh config to enable login to controller host:
4. Manually add entry in /etc/sudoers.d/<username> to allow password-less sudo for ansible tasks
5. Run controller host initialization script to prepare for controller installation (see below). Installs python and docker.
6. Run install controller script (see below). Runs ansible playbook to install controller on controller host.
7. Run controller initialization script (see below). Runs ansible playbook to configure the controller.
8. (Optional) Run reset-controller host script to prior to restarting procedure at step 6 above.
