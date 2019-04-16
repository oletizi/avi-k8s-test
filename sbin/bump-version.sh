#!/bin/bash

# Thanks goes to @pete-otaqui for the initial gist:
# https://gist.github.com/pete-otaqui/4188238
#
# Original version modified by Marek Suscak
#
# works with a file called VERSION in the current directory,
# the contents of which should be a semantic version number
# such as "1.2.3" or even "1.2.3-beta+001.ab"

# this script will display the current version, automatically
# suggest a "minor" version update, and ask for input to use
# the suggestion, or a newly entered value.

# once the new version number is determined, the script will
# pull a list of changes from git history, prepend this to
# a file called ${CHANGELOG_FILE} (under the title of the new version
# number), give user a chance to review and update the changelist
# manually if needed and create a GIT tag.

mydir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
root=$( cd "${mydir}/.." && pwd )
bin=$(cd "${root}/bin" && pwd )

. ${mydir}/config.sh
. ${bin}/config.sh

VERSION_FILE="${root}/VERSION"
CHANGELOG_FILE="${root}/CHANGELOG.md"


NOW="$(date +'%B %d, %Y')"
RED="\033[1;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
PURPLE="\033[1;35m"
CYAN="\033[1;36m"
WHITE="\033[1;37m"
RESET="\033[0m"
QUESTION_FLAG="${GREEN}?"
WARNING_FLAG="${YELLOW}!"
NOTICE_FLAG="${CYAN}❯"

if [[ ! -f ${VERSION_FILE} ]]; then
  echo -e "${WARNING_FLAG} Can't find version file: ${VERSION_FILE}"
  exit 1
fi

LATEST_HASH=$(git log --pretty=format:'%h' -n 1)
assert_not_empty "Failed to get latest git hash" ${LATEST_HASH}

ADJUSTMENTS_MSG="${QUESTION_FLAG} ${CYAN}Now you can make adjustments to ${WHITE}${CHANGELOG_FILE}${CYAN}. Then press enter to continue."
PUSHING_MSG="${NOTICE_FLAG} Pushing new version to the ${WHITE}origin${CYAN}..."

tmpfile=$(mktemp)

if [[ -f ${VERSION_FILE} ]]; then
    BASE_STRING=$(cat ${VERSION_FILE})
    assert_not_empty "Base version string undefined." ${BASE_STRING}

    BASE_LIST=($(echo ${BASE_STRING} | sed -E 's/([0-9]+).([0-9]+).([0-9]+)([^0-9]*)/\1 \2 \3 \4/'))

    V_MAJOR=${BASE_LIST[0]}
    V_MINOR=${BASE_LIST[1]}
    V_PATCH=${BASE_LIST[2]}
    V_FLAGS=${BASE_LIST[3]}
    echo "major: $V_MAJOR"
    echo "minor: $V_MINOR"
    echo "patch: $V_PATCH"
    echo "flags: $V_FLAGS"
    echo -e "${NOTICE_FLAG} Current version: ${WHITE}$BASE_STRING"
    echo -e "${NOTICE_FLAG} Latest commit hash: ${WHITE}$LATEST_HASH"
    V_MINOR=$((V_MINOR + 1))
    V_PATCH=0
    SUGGESTED_VERSION="${V_MAJOR}.${V_MINOR}.${V_PATCH}${V_FLAGS}"
    echo -ne "${QUESTION_FLAG} ${CYAN}Enter a version number [${WHITE}${SUGGESTED_VERSION}${CYAN}]: "
    read INPUT_STRING
    if [[ "$INPUT_STRING" = "" ]]; then
        INPUT_STRING=${SUGGESTED_VERSION}
    fi
    echo -e "${NOTICE_FLAG} Will set new version to be ${WHITE}$INPUT_STRING"
    echo ${INPUT_STRING} > ${VERSION_FILE} \
      && echo "## $INPUT_STRING ($NOW)" > ${tmpfile} \
      && git log --pretty=format:"  - %s" "v${BASE_STRING}...HEAD" >> ${tmpfile} \
      && echo "" >> ${tmpfile} \
      && echo "" >> ${tmpfile} \
      && cat ${CHANGELOG_FILE} >> ${tmpfile} \
      && mv ${tmpfile} ${CHANGELOG_FILE} \
      && echo -e "$ADJUSTMENTS_MSG"
      read
      echo -e "$PUSHING_MSG" \
      && git add ${CHANGELOG_FILE} ${VERSION_FILE} \
      && git commit -m "Bump version to ${INPUT_STRING}." \
      && git tag -a -m "Tag version ${INPUT_STRING}." "v$INPUT_STRING" \
      && git push origin --tags \
      && echo -e "${NOTICE_FLAG} Finished."
else
    echo -e "${WARNING_FLAG} Could not find a VERSION file."
    exit 1
fi

