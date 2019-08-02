#!/bin/bash

export MARID_HOME=/home/marid
export REMCO_HOME=/etc/remco
export REMCO_RESOURCE_DIR=${REMCO_HOME}/resources.d
export REMCO_TEMPLATE_DIR=${REMCO_HOME}/templates

CONF_PATH=${CONF_PATH:-'/etc/opsgenie/marid/marid.conf'}
LOG_CONF_PATH=${LOG_CONF_PATH:-'/etc/opsgenie/marid/log.properties'}
SCRIPTS_DIR=${SCRIPTS_DIR:-'/var/opsgenie/marid/scripts'}
LOGS_DIR=${LOGS_DIR:-'/var/opsgenie/marid/log'}
MEM_LIMIT=${MEM_LIMIT:-'512'}
DJAVAX_NET_DEBUG=${DJAVAX_NET_DEBUG:-''}

remco

java \
  -Dmarid.config=/etc/opsgenie/marid \
  -Dmarid.conf.path="$CONF_PATH" \
  -Dmarid.log.conf.path="$LOG_CONF_PATH" \
  -Dmarid.scripts.dir="$SCRIPTS_DIR" \
  -Dmarid.logs.dir="$LOGS_DIR" \
  -Djava.io.tmpdir=/tmp/marid \
  -Xms256m \
  -Xmx${MEM_LIMIT}m \
  -XX:MaxPermSize=128m \
  -XX:+HeapDumpOnOutOfMemoryError \
  -server \
  -Djavax.net.debug="$DJAVAX_NET_DEBUG" \
  -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=17777 \
  -cp MARID_CLASSPATH:/var/lib/opsgenie/marid/* com.ifountain.opsgenie.client.marid.Bootstrap

