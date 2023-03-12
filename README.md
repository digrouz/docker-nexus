[![auto-update](https://github.com/digrouz/docker-nexus/actions/workflows/auto-update.yml/badge.svg)](https://github.com/digrouz/docker-nexus/actions/workflows/auto-update.yml)
[![dockerhub](https://github.com/digrouz/docker-nexus/actions/workflows/dockerhub.yml/badge.svg)](https://github.com/digrouz/docker-nexus/actions/workflows/dockerhub.yml)
![Docker Pulls](https://img.shields.io/docker/pulls/digrouz/nexus)

# docker-nexus
Install Sonatype Nexus Repository Manager into a Linux Container

![Nexus](https://help.sonatype.com/download/attachments/2628561/NXRM3?version=2&modificationDate=1502243125680&api=v2)

## Tag
Several tag are available:
* latest: see alpine
* alpine: [Dockerfile_alpine](https://github.com/digrouz/docker-nexus/blob/master/Dockerfile_alpine)

## Description

Sonatype Nexus, an artifact repository for building software;

https://www.sonatype.com/nexus-repository-oss

## Usage
    docker create --name=nexus  \
      -v /etc/localtime:/etc/localtime:ro \
      -v <path to persistant data>:/nexus-work \
      -e UID=<UID default:12345> \
      -e GID=<GID default:12345> \
      -e AUTOUPGRADE=<0|1 default:0> \
      -e TZ=<timezone default:Europe/Brussels> \
      -p 8081:8081 digrouz/nexus


## Environment Variables

When you start the `nexus` image, you can adjust the configuration of the `nexus` instance by passing one or more environment variables on the `docker run` command line.

### `UID`

This variable is not mandatory and specifies the user id that will be set to run the application. It has default value `12345`.

### `GID`

This variable is not mandatory and specifies the group id that will be set to run the application. It has default value `12345`.

### `AUTOUPGRADE`

This variable is not mandatory and specifies if the container has to launch software update at startup or not. Valid values are `0` and `1`. It has default value `0`.

### `TZ`

This variable is not mandatory and specifies the timezone to be configured within the container. It has default value `Europe/Brussels`.

## Notes

* This container is built using [s6-overlay](https://github.com/just-containers/s6-overlay)
* The docker entrypoint can upgrade operating system at each startup. To enable this feature, just add `-e AUTOUPGRADE=1` at container creation.
* Don't forget to change the default password the `admin` user: `admin123` after first login.

## Issues

If you encounter an issue please open a ticket at [github](https://github.com/digrouz/docker-nexus/issues)
