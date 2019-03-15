# Testing for Avi in Kubernetes

## Description

A collection of ansible configuration files and bash scripts used to test setting up Avi Vantage for use in
front of a Kubernetes cluster.

## Procedure

1. Manually create a Kubernetes cluster
2. Create a GCP instance to serve as host for the Avi controller
3. Manually add publish ssh key to ~/.ssh/authorized_keys
4. Manually add entry in /etc/sudoers.d/<username> to allow password-less sudo for ansible tasks
5. Run controller host initialization script to prepare for controller installation (see below). Installs python and docker.
6. Run install controller script (see below). Runs ansible playbook to install controller on controller host.
7. Run controller initialization script (see below). Runs ansible playbook to configure the controller.
8. (Optional) Run reset-controller host script to prior to restarting procedure at step 6 above.

## Contents
### ``/ansible``
* ``avi_config.yml``&mdash;ansible file from Ranga for configuring the controller
* ``avi_creds.yml``&mdash;ansible file from Ranga for setting configuration values; *NOTE: project_name and kube_master_node modified to match test Kubernetes cluster*
* ``controller.yml``&mdash;ansible file for specifying controller details
* ``hosts.yml``&mdash;ansible hosts file from Ranga, updated with test Kubernetes cluster details
* ``k8s_cloud_gcp.yaml``&mdash;ansible playbook from Ranga for configuring the controller. *NOTE: password change task
commented out b/c the default password is unknown. This requires a manual step of initial controller setup via the
controller web UI.*
* ``k8s_cloud_vmw.yaml``&mdash;ansible playbook from Ranga for VMware. Not used.

### ``/bin``
* ``01-create-controller-host-gcp.sh``&mdash;script to create a GCP instance to act as controller host.
* ``02-init-controller-host.sh``&mdash;script to prepare the controller host for controller installation.
* ``03-install-controller.sh``&mdash;script to install controller on controller host.
* ``04-init-controller-gcp.sh``&mdash;script to run k8s_cloud_gcp.yaml playbook with test kubernetes cluster details
* ``reset-controller-host.sh``&mdash;convenience script to reset the controller host in order to run the controller
installation playbook again for a fresh container installation.
* ``test-service-token.sh``&mdash;script to test the service account auth token to make sure it works.
