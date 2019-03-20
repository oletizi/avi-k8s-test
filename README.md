# Testing for Avi in Kubernetes

## Description

A tutorial kit to test running an Avi Vantage Controller in front of a Kuberetes cluster.

## Purpose

*TODO* 

## Requirements
* A host capable of running a small Ubuntu docker image
* A Google Cloud Platform account with the ability to instantiate Google Compute Engine instances and create Google 
  Kubernetes Engine clusters

## Procedure Overview

**IMPORTANT:** DO NOT FORGET TO RUN THE CLEANUP SCRIPT AFTER WORKING THROUGH THIS TUTORIAL.

Some of the resources created in this tutorial are large and could be expensive if left running.

--- 

All of the configuration and deployment will be done inside an Ubuntu docker container with all the necessary
packages installed. 

This project directory is mounted inside the container at /home/ubuntu/avi-k8s-test; should you
wish to make changes to scripts or configuration, you may do so from the docker host machine and they will also appear
in the configuration container. 

1. Install docker

1. Start and login to the configuration container: 
  
    ``/home/ubuntu/avi-k8s-test/bin/00-start-config-container.sh`` 

1. From the configuration container, install and configure the gcloud CLI:
  
    ``/home/ubuntu/avi-k8s-test/bin/01-install-gcloud.sh``

   Follow the directions to login to your gcloud account and set your default project and zone

1. From the configuration container, create the test Kubernetes cluster:
  
    ``/home/ubuntu/avi-k8s-test/bin/02-create-cluster.sh``

    This may take a minute or so.

1. Once the Kubernetes cluster is created, configure the cluster:

    ``/home/ubuntu/avi-k8s-test/bin/03-configure-cluster.sh``
   
   This applies appropriate permissions to the cluster's default service account and stores the service account's
   credential token in a local file for use by Ansible.

1. Create a Google Compute Engine instance to serve as host for the Avi controller:
  
    ``/home/ubuntu/avi-k8s-test/bin/04-create-controller-host.sh``
    
   This may take a minute or so.
   
1. Gather the Kubernetes cluster master endpoint IP address, the Avi Controller IP address, and the Avi Controller
hostname into a temporary configuration file: ``/home/ubuntu/.avi-demo-config``  

    ``/home/ubuntu/avi-k8s-test/bin/05-gather-config.sh``
    
1. Test the Kubernetes cluster service account token:

    ``/home/ubuntu/avi-k8s-test/bin/test-service-token.sh``
    
    *TODO: rename this script so it sorts properly*
    
1. Prepare the Avi Controller host for installation:

    ``/home/ubuntu/avi-k8s-test/bin/06-config-controller-host.sh``

1. Install the Avi Controller on the Controller host:

    ``/home/ubuntu/avi-k8s-test/bin/07-install-controller.sh``
    
   This may take a minute or so while the Controller docker image is pulled onto the host.
   
   *TODO: add support for waiting until the controller is ready before moving on to the next step.* 

1. Configure the Avi Controller to work with the Kubernetes cluster:

    ``/home/ubuntu/avi-k8s-test/bin/08-config-controller.sh <default admin password>``
    
   ***NOTE:** This **still** doesn't work properly. Now that this process is relatively foolproof and the configuration
   is stable, please fork this repo and make pull requests to add the magic words so this step will work. Thanks in advance.*
   
1. Tear down all of the resources created in this tutorial:

    ``/home/ubuntu/avi-k8s-test/bin/100-cleanup.sh``
    
   *TODO: Remove all firewall rules.*