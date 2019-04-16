#!/usr/bin/env bash

set -exv

mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/.." && pwd )
version_file="${root}/VERSION"

. "${mydir}/config.sh"
. "${root}/bin/config.sh"

# ensure we're up to date
git pull \
  && "${mydir}"/bump-version.sh \
  && version=$(cat "$version_file") \
  && assert_not_empty "Failed to determine version!" ${version} \
  && echo "version: ${version}" \
  && "${mydir}"/build.sh \
  && git add -A \
  && git commit -m "version $version" \
  && git tag -a "$version" -m "version $version" \
  && git push \
  && git push --tags
assert_success $? "Release failed!"

