# docker-nexus
Install Sonatype Nexus Repository Manager into a Linux Container

![Nexus](https://help.sonatype.com/download/attachments/2628561/NXRM3?version=2&modificationDate=1502243125680&api=v2)


## Description

Sonatype Nexus, an artifact repository for building software;

https://www.sonatype.com/nexus-repository-oss

## Usage
    docker create --name=nexus  \
      -v /etc/localtime:/etc/localtime:ro \
      -v <path to persistant data>:/nexus-work \
      -e DOCKUID=<UID default:10023> \
      -e DOCKGID=<GID default:10023> \
      -e DOCKUPGRADE=<0|1> \
      -p 8081:8081 digrouz/nexus


## Environment Variables

When you start the `nexus` image, you can adjust the configuration of the `nexus` instance by passing one or more environment variables on the `docker run` command line.

### `DOCKUID`

This variable is not mandatory and specifies the user id that will be set to run the application. It has default value `10023`.

### `DOCKGID`

This variable is not mandatory and specifies the group id that will be set to run the application. It has default value `10023`.

### `DOCKUPGRADE`

This variable is not mandatory and specifies if the container has to launch software update at startup or not. Valid values are `0` and `1`. It has default value `0`.

## Notes

* The docker entrypoint can upgrade operating system at each startup. To enable this feature, just add `-e DOCKUPGRADE=1` at container creation.
* Don't forget to change the default password the `admin` user: `admin123` after first login.


