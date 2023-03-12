#!/usr/bin/env bash

NEXUS_URL="https://api.github.com/repos/sonatype/nexus-public/releases"

/bin/bash: q : commande introuvable
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
