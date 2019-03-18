#!/usr/bin/env bash

mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cd ${mydir} \
  && . config.sh \
  && if [[ "" != $( docker ps | grep ${localhost_container} ) ]]; then
    docker kill ${localhost_container} && docker rm ${localhost_container}
  fi \
  && docker run -d --name ${localhost_container} ${localhost_image}