#!/bin/sh
${KAKFKA_HOME}/bin/zookeeper-server-start.sh -daemon ${KAKFKA_HOME}/config/zookeeper.properties
sleep 2
${KAKFKA_HOME}/bin/kafka-server-start.sh ${KAKFKA_HOME}/config/server.properties
sleep 2
${KAKFKA_HOME}/bin/kafka-topics.sh --zookeeper localhost:2181 --create --topic massice-events --replication-factor 1 --partitions 1

