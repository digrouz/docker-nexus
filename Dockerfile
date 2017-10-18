FROM centos:latest
LABEL maintainer "DI GREGORIO Nicolas <ndigrego@ndg-consulting.tech>"

# Environment variables
ENV LANG='en_US.UTF-8' \
    LANGUAGE='en_US.UTF-8' \
    TERM='xterm' \
    JAVA_URL='http://javadl.oracle.com/webapps/download/AutoDL?BundleId=227541_e758a0de34e24606bca991d704f6dcbf' \
    NEXUS_VERSION='3.6.0-02'

# Install Application
RUN yum install -y curl tar createrepo && \
    curl --fail --silent --location --retry 3 --header "Cookie: oraclelicense=accept-securebackup-cookie" ${JAVA_URL} -o /tmp/oracle-jre.rpm && \
    yum install -y /tmp/oracle-jre.rpm && \
    curl --fail --silent --location --retry 3 http://download.sonatype.com/nexus/3/nexus-${NEXUS_VERSION}-unix.tar.gz -o /tmp/nexus-${NEXUS_VERSION}-unix.tar.gz && \
    mkdir  -p /opt/sonatype /nexus /nexus-work && \
    tar xzf /tmp/nexus-${NEXUS_VERSION}-unix.tar.gz -C /tmp && \
    mv /tmp/nexus-${NEXUS_VERSION} /opt/sonatype && \
    yum clean all && \
    rm -rf /tmp/* \
           /var/cache/yum/* \
           /var/tmp/*
    
# Expose volumes
VOLUME ["/nexus-work"]

# Expose ports
EXPOSE 8081

# Running User: not used, managed by docker-entrypoint.sh
#USER nexus

# Start nexus
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nexus"]
