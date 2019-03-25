#!/usr/bin/env bash

cd /tmp/
curl https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-239.0.0-linux-x86_64.tar.gz | tar xfvz -
/tmp/google-cloud-sdk/install.sh
gcloud init
