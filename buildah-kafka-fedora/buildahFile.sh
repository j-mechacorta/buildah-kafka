#!/usr/bin/env bash

set -x

baseimage=fedora:33
imageversion=0.0.2
ctr=$(buildah from $baseimage)

buildah config  $ctr
buildah run $ctr -- dnf install java-1.8.0-openjdk-headless.x86_64 wget -y
buildah run $ctr -- dnf clean all -y 
buildah run $ctr -- rm -rf /var/cache/dnf

buildah run $ctr -- mkdir -p /opt/binaries
buildah run $ctr -- /usr/bin/wget https://archive.apache.org/dist/kafka/0.10.2.2/kafka_2.12-0.10.2.2.tgz -O /opt/binaries/kafka_2.12-0.10.2.2.tgz
# buildah copy $ctr kafka_2.12-0.10.2.2.tgz /opt/binaries 
buildah run $ctr /bin/sh -c 'cd /opt/binaries && tar xfz kafka_2.12-0.10.2.2.tgz && rm kafka_2.12-0.10.2.2.tgz'
buildah run $ctr /bin/sh -c 'cd /opt && ln -s /opt/binaries/kafka_2.12-0.10.2.2 /opt/kafka'

buildah copy $ctr ../conf/server.properties /opt/kafka/conf
buildah copy $ctr ../conf/start-services.sh .

buildah config --env KAKFKA_HOME="/opt/kafka" $ctr

buildah run $ctr /bin/sh -c 'chmod +x start-services.sh'
# buildah config --volume /opt/kafka/conf $ctr
buildah config --port 9092 --entrypoint '["./start-services.sh"]' $ctr

buildah config --author='aa @ local' --created-by='zebraKai'  --label name=kafka-server $ctr
buildah unmount $ctr
buildah commit $ctr kafka-server:$imageversion