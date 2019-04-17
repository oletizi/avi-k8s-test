#!/usr/bin/env bash

set -ex

mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/.." && pwd )
bin=$( cd "${root}/bin" && pwd)

. "${bin}/config.sh"

"${root}"/docker/avi-k8s-demo-localhost/build.sh
assert_success $? "Docker build failed!"