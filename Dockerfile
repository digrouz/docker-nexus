FROM centos:latest
LABEL maintainer "DI GREGORIO Nicolas <ndigrego@ndg-consulting.tech>"

# Environment variables
ENV LANG='en_US.UTF-8' \
    LANGUAGE='en_US.UTF-8' \
    TERM='xterm' \
    JAVA_URL='http://javadl.oracle.com/webapps/download/AutoDL\?BundleId\=227541_e758a0de34e24606bca991d704f6dcbf'

# Install Application
RUN yum install -y curl tar createrepo && \
    curl --fail --silent --location --retry 3 --header "Cookie: oraclelicense=accept-securebackup-cookie;" -o /tmp/oracle/jre.rpm ${JAVA_URL} && \
    yum install -y /tmp/oracle/jre.rpm && \
    yum clean all && \
    rm -rf /tmp/* \
           /var/cache/yum/* \
           /var/tmp/*
    
# Expose volumes
#VOLUME []

# Expose ports
EXPOSE 8081

# Running User: not used, managed by docker-entrypoint.sh
#USER nexus

# Start nexus
#COPY ./docker-entrypoint.sh /
#ENTRYPOINT ["/docker-entrypoint.sh"]
#CMD ["nexus"]
