# Buildah script to create a kafka server

This image is based on a fedora image which is not as lightweight as something like alpine. 


> **IMPORTANT**
> it's intended to be for testing purposes and no optimizations or configuration changes have been implemented other than the listener_ip.

## requirements:
- podman
- buildah

## Install packages (fedora/rhel/centos)
```sh
$ dnf install podman buildah
 ```

## Start Container
```sh
podman run --name kafkapod -p 9092:9092 {{ container_id | container_name:tag }}
```