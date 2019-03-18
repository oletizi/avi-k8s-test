#!/usr/bin/env bash
mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )



cd ${mydir} \
  && . ./config.sh \
  && docker build -f ./Dockerfile -t ${localhost_image} .