FROM centos:7
LABEL maintainer "DI GREGORIO Nicolas <ndigrego@ndg-consulting.tech>"

ARG NEXUS_VERSION=3.15.2-01
ARG NEXUS_DOWNLOAD_URL=https://download.sonatype.com/nexus/3/nexus-${NEXUS_VERSION}-unix.tar.gz

# Environment variables
ENV LANG='en_US.UTF-8' \
    LANGUAGE='en_US.UTF-8' \
    TERM='xterm' \
    NEXUS_VERSION="${NEXUS_VERSION}" \
    NEXUS_DOWNLOAD_URL="${NEXUS_DOWNLOAD_URL}"\
    SONATYPE_DIR="/opt/sonatype" \
    APPUSER="nexus" \
    APPGID="10023" \
    APPUID="10023"
ENV NEXUS_HOME="${SONATYPE_DIR}/nexus" \
    NEXUS_DATA="/nexus-data" \
    NEXUS_WORK="/nexus-work" \
    NEXUS_CONTEXT='' \
    SONATYPE_WORK="${SONATYPE_DIR}/sonatype-work" \
    INSTALL4J_ADD_VM_PARAMS="-Xms1200m -Xmx1200m -XX:MaxDirectMemorySize=2g -Djava.util.prefs.userRoot=${NEXUS_DATA}/javaprefs"

COPY root /

# Install Application
RUN set -x && \
    chmod 1777 /tmp && \
    . /usr/local/bin/docker-entrypoint-functions.sh && \
    MYUSER="${APPUSER}" && \
    MYUID="${APPUID}" && \
    MYGID="${APPGID}" && \
    ConfigureUser && \
    usermod -m -d ${SONATYPE_DIR} ${MYUSER} && \
    yum-config-manager --add-repo /tmp/custom.repo && \
    yum update -y && \
    yum install -y \
      curl \
      tar \
      createrepo \
      java-1.8.0-openjdk-headless.x86_64 \
      su-exec \
    && \
    curl --fail --silent --location --retry 3 http://download.sonatype.com/nexus/3/nexus-${NEXUS_VERSION}-unix.tar.gz -o /tmp/nexus-${NEXUS_VERSION}-unix.tar.gz && \
    mkdir -p ${SONATYPE_DIR} ${NEXUS_WORK} ${NEXUS_DATA} && \
    tar xzf /tmp/nexus-${NEXUS_VERSION}-unix.tar.gz -C /tmp && \
    mv /tmp/nexus-${NEXUS_VERSION} ${NEXUS_HOME} && \
    ln -snf ${NEXUS_WORK} ${SONATYPE_WORK} && \
    sed \
      -e '/^-Xms/d' \
      -e '/^-Xmx/d' \
      -e '/^-XX:MaxDirectMemorySize/d' \
    ${NEXUS_HOME}/bin/nexus.vmoptions && \
    chown -R ${MYUSER}:${MYUSER} ${SONATYPE_DIR} ${NEXUS_HOME} ${SONATYPE_WORK} ${NEXUS_WORK} ${NEXUS_DATA} && \
    yum clean all && \
    mkdir /docker-entrypoint.d && \
    chmod +x /usr/local/bin/docker-entrypoint.sh && \
    ln -snf /usr/local/bin/docker-entrypoint.sh /docker-entrypoint.sh && \
    rm -rf /tmp/* \
           /var/cache/yum/* \
           /var/tmp/*
    
# Expose volumes
VOLUME ["${NEXUS_DATA}"]

# Expose ports
EXPOSE 8081

# Running User: not used, managed by docker-entrypoint.sh
#USER nexus

# Start nexus
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nexus"]
