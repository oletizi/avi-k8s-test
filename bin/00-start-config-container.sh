#!/usr/bin/env bash

mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/.." && pwd )

${root}/docker/localhost/run.sh
docker exec -it avi-k8s-test-localhost "/bin/bash"
