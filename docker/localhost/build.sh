#!/usr/bin/env bash

mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/../.." && pwd )
bin=$( cd "${root}/bin" && pwd )

. "${bin}/config.sh"
. "${mydir}/config.sh"
build_cmd="docker build --build-arg ansible_playbook_version=${AVI_DEMO_ANSIBLE_PLAYBOOK_VERSION} -f ./Dockerfile -t ${localhost_image} ."

echo "Building ${localhost_image} with build command:"
echo
echo "    ${build_cmd}"
echo

cd ${mydir} \
   && ${build_cmd} \
    && docker push ${localhost_image}
