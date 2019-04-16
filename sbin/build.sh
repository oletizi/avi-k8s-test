#!/usr/bin/env bash

set -exv

mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/.." && pwd )
bin=$( cd "${root}/bin" && pwd)

"${root}"/docker/avi-k8s-demo-localhost/build.sh
assert_success $? "Docker build failed!"