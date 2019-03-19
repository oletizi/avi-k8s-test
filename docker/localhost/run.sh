#!/usr/bin/env bash

mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/../../" && pwd)
bin=$( cd "${root}/bin" && pwd )

. ${mydir}/config.sh

docker pull ${localhost_image} 

if [[ "" != $(docker ps | grep ${localhost_container}) ]]; then
    cmd="docker kill ${localhost_container}"
    echo "Killing running container: ${cmd}"
    exec ${cmd}
fi

if [[ "" != $(docker ps -a | grep ${localhost_container}) ]]; then    
    cmd="docker rm ${localhost_container}"
    echo "Removing stopped container: ${cmd}"
    exec ${cmd}
fi

cmd="docker run -d -v ${root}:/home/ubuntu/avi-k8s-test --name ${localhost_container} ${localhost_image}"
echo "Running container: ${cmd}"
exec ${cmd}
