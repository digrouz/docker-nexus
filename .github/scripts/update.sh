#!/usr/bin/env bash

NEXUS_URL="https://api.github.com/repos/sonatype/nexus-public/releases"

FULL_LAST_VERSION=$(curl -SsL ${NEXUS_URL} | \
              jq -r -c '.[] | select( .prerelease == false ) | .tag_name' |\
              | egrep -v "^2" |\
              head -1 \
              )
LAST_VERSION="${FULL_LAST_VERSION:8}"

if [ "${LAST_VERSION}" ]; then
  sed -i -e "s|NEXUS_VERSION='.*'|NEXUS_VERSION='${LAST_VERSION}'|" Dockerfile*
fi

if output=$(git status --porcelain) && [ -z "$output" ]; then
  # Working directory clean
  echo "No new version available!"
else 
  # Uncommitted changes
  git commit -a -m "update to version: ${LAST_VERSION}"
  git push
fi
