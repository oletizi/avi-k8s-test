#!/usr/bin/env bash

mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/../../" && pwd)

cd ${mydir}
. config.sh 
docker pull ${localhost_image} 
docker kill ${localhost_container}
docker rm ${localhost_container}
docker run -d -v ${root}:/home/ubuntu/avi-k8s-test --name ${localhost_container} ${localhost_image}
