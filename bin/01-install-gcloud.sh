#!/usr/bin/env bash

mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/.." && pwd )

. ${mydir}/config.sh

cmd="gcloud ${AVI_DEMO_GCLOUD_VERBOSITY} init --console-only --skip-diagnostics"
echo "Intializing gcloud: ${cmd}"
${cmd}
assert_success $? "Unable to intialize gcloud. Please try again."

journal "01"
