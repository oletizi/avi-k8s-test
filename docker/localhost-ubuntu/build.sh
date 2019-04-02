#!/usr/bin/env bash

mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/../.." && pwd )
bin=$( cd "${root}/bin" && pwd )

. "${bin}/config.sh"
. "${mydir}/config.sh"

# XXX: Using build args isn't the most elegant solution to passing these values
build_cmd="docker build --build-arg avisdk_role_version=${AVI_DEMO_AVISDK_ROLE_VERSION} --build-arg aviconfig_role_version=${AVI_DEMO_AVICONFIG_ROLE_VERSION} --build-arg avicontroller_role_version=${AVI_DEMO_AVICONTROLLER_ROLE_VERSION}  -f ./Dockerfile -t ${localhost_image} ."

echo "Building ${localhost_image} with build command:"
echo
echo "    ${build_cmd}"
echo

cd ${mydir} \
   && ${build_cmd} \
    && docker push ${localhost_image}
