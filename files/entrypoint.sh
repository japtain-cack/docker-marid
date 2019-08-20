#!/bin/bash

export MARID_HOME=/var/opsgenie/marid
export MARID_CONF=/etc/opsgenie/marid
export OPSGENIE_CONF=/etc/opsgenie/conf
export MARID_LIB=/var/lib/opsgenie/marid
export REMCO_HOME=/etc/remco
export REMCO_RESOURCE_DIR=${REMCO_HOME}/resources.d
export REMCO_TEMPLATE_DIR=${REMCO_HOME}/templates

export MEM_LIMIT=${MEM_LIMIT:-'512'}
export DJAVAX_NET_DEBUG=${DJAVAX_NET_DEBUG:-''}
export CLASSPATH=$CLASSPATH:"$MARID_HOME/lib/*"
export CLASSPATH=$CLASSPATH:"$MARID_LIB/*"

if [[ "${HTTP_SERVER_HOST}" == "eth0" ]]; then
  export HTTP_SERVER_HOST=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)
fi

remco

cat <<EOF > ${MARID_HOME}/scripts/test.groovy
import java.text.SimpleDateFormat
def date = new Date()
sdf = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss")
println sdf.format(date)
return sdf.format(date)
EOF

java \
  -Dmarid.config="$MARID_CONF" \
  -Dmarid.conf.path="$MARID_CONF/marid.conf" \
  -Dmarid.log.conf.path="$MARID_CONF/log.properties" \
  -Dmarid.scripts.dir="$MARID_HOME/scripts" \
  -Dmarid.logs.dir="$MARID_HOME/logs" \
  -Djava.io.tmpdir="/tmp/marid" \
  -Xms256m \
  -Xmx${MEM_LIMIT}m \
  -XX:MaxPermSize=128m \
  -XX:+HeapDumpOnOutOfMemoryError \
  -server \
  -Djavax.net.debug="$DJAVAX_NET_DEBUG" \
  -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=17777 \
  -cp $CLASSPATH com.ifountain.opsgenie.client.marid.Bootstrap

