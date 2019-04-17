#!/usr/bin/env bash

mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/.." && pwd )
docker_dir=$( cd "${root}/docker/avi-k8s-demo-localhost" && pwd )

. ${mydir}/config.sh
. ${docker_dir}/config.sh

assert_not_empty "Docker container name undefined!" ${localhost_container}

${docker_dir}/run.sh && docker exec -it  ${localhost_container} "/bin/bash"
