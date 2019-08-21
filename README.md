# docker-marid
Run a marid server in a Docker container

[![Docker Automated build](https://img.shields.io/docker/automated/nsnow/docker-marid.svg)](https://hub.docker.com/r/nsnow/docker-marid)
[![Docker Stars](https://img.shields.io/docker/stars/nsnow/docker-marid.svg)](https://hub.docker.com/r/nsnow/docker-marid)
[![Docker Pulls](https://img.shields.io/docker/pulls/nsnow/docker-marid.svg)](https://hub.docker.com/r/nsnow/docker-marid)
[![Docker Build Status](https://img.shields.io/docker/build/nsnow/docker-marid.svg)](https://hub.docker.com/r/nsnow/docker-marid/builds)


This Dockerfile will download the marid Server app and set it up, along with its dependencies.

This version of marid contains the Jira Service Desk components and is intended to be used with that system.

https://docs.opsgenie.com/docs/jiraservicedesk-integration

https://github.com/opsgenie/opsgenie-integration/tree/master/jiraservicedesk

Remco is used to manage static configuration files in the container. To customize your conf files, use the `-e <environment var>=<value>` flag in your docker run command. Conf files will be overwritten every time the container is launched.


## Example

Use this `docker run` command to launch a container.

**NOTE: You will need to review the possible environment variables to configure the marid server and include those in the docker run command (see below).**

 $ `docker run -d -it --name=marid -v /opt/marid:/var/opsgenie/marid/static -p 8080:8080/tcp -e MYVAR=myValue nsnow/docker-marid:latest`


## Additional Docker commands

**kil and remove all docker containers**

`docker kill $(docker ps -qa); docker rm $(docker ps -qa)`

**docker logs**

`docker logs marid`

**attach to the minecraft server console**

`docker attach marid`

**exec into the container's bash console**

`docker exec marid bash`


**NOTE**: referencing containers by name is only possible if you specify the `--name` flag in your docker run command.


## Set selinux context for mounted volumes

`chcon -Rt svirt_sandbox_file_t /path/to/volume`


## Server properties and environment variables
https://github.com/japtain-cack/docker-marid/tree/master/remco/templates
 
