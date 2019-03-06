#!/usr/bin/env bash

. /etc/profile
. /usr/local/bin/docker-entrypoint-functions.sh

MYUSER="${APPUSER}"
MYUID="${APPUID}"
MYGID="${APPGID}"

AutoUpgrade
ConfigureUser

if [ "${1}" == 'nexus' ]; then
  DockLog "Adjusting system limits"
  ulimit -n 65536 -u 4096
  DockLog "Fixing permissions on ${SONATYPE_DIR} ${NEXUS_HOME} ${SONATYPE_WORK} ${NEXUS_DATA}"
  chown -R ${MYUSER}:${MYUSER} ${SONATYPE_DIR} ${NEXUS_HOME} ${SONATYPE_WORK} ${NEXUS_DATA}

  RunDropletEntrypoint

  cd ${NEXUS_HOME} 
  DockLog "Starting application: ${1}"
  exec su-exec "${MYUSER}" bin/nexus run
else
  DockLog "Lauching command: $@"
  exec "$@"
fi
