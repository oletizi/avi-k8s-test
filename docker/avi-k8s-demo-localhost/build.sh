#!/usr/bin/env bash

mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/../.." && pwd )
bin=$( cd "${root}/bin" && pwd )
sbin=$( cd "${root}/sbin" && pwd )
. "${sbin}/config.sh"
. "${bin}/config.sh"
. "${mydir}/config.sh"

assert_not_empty "Version for avisdk ansible role not set!" ${AVI_DEMO_AVISDK_ROLE_VERSION}
assert_not_empty "Version for aviconfig ansible role not set!" ${AVI_DEMO_AVICONFIG_ROLE_VERSION}
assert_not_empty "Version for avicontroller ansible role not set!" ${AVI_DEMO_AVICONTROLLER_ROLE_VERSION}
assert_not_empty "Docker image name not defined!" ${localhost_image}

version=$(cat "${root}/VERSION")
assert_not_empty "Can't determine version!" ${version}

# XXX: Using build args isn't the most elegant solution to passing these values
build_cmd="docker build -t ${localhost_image}:latest -t ${localhost_image}:${version} --build-arg avisdk_role_version=${AVI_DEMO_AVISDK_ROLE_VERSION} --build-arg aviconfig_role_version=${AVI_DEMO_AVICONFIG_ROLE_VERSION} --build-arg avicontroller_role_version=${AVI_DEMO_AVICONTROLLER_ROLE_VERSION}  -f ./Dockerfile -t ${localhost_image} ."

echo "Building ${localhost_image} with build command:"
echo
echo "    ${build_cmd}"
echo

cd ${mydir} && ${build_cmd}
