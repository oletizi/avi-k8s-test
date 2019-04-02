#!/usr/bin/env bash

sudo chown ubuntu:ubuntu /home/ubuntu
ansible-galaxy install \
  avinetworks.aviconfig,18.2.1 \
  avinetworks.avicontroller,18.2.1 \
  avinetworks.avisdk,18.2.1

