#!/usr/bin/env bash

if [[ $1 == "" ]]; then
  echo "Please specify version string"
  echo
  echo "Usage:"
  echo "  tag-image.sh [version-string]"
  echo
  exit 1
fi

mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/../.." && pwd )
bin=$( cd "${root}/bin" && pwd )
sbin=$( cd "${root}/sbin" && pwd )
. "${sbin}/config.sh"
. "${bin}/config.sh"
. "${mydir}/config.sh"

assert_not_empty "Dockerhub username is not specified" ${DOCKERHUB_USERNAME}
assert_not_empty "Docker image name is not specified" ${localhost_image}


