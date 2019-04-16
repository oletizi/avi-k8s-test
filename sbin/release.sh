#!/usr/bin/env bash

set -exv

mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/.." && pwd )
docker=$( cd "${root}/docker/avi-k8s-demo-localhost" && pwd )
version_file="${root}/VERSION"

. "${mydir}/config.sh"
. "${root}/bin/config.sh"
. "${docker}/config.sh"

assert_not_empty "Localhost docker image name not defined!" ${localhost_image}

# ensure we're up to date
git pull \
  && "${mydir}"/bump-version.sh \
  && version=$(cat "$version_file") \
  && assert_not_empty "Failed to determine version!" ${version} \
  && echo "version: ${version}" \
  && "${mydir}"/build.sh \
  && git push \
  && git push --tags \
  && docker push ${localhost_image}:${version}
assert_success $? "Release failed!"

