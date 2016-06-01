#!/bin/sh

## AGENT_UUID is cm agent's identity in Cloudera Manager
## By using a consistent UUID, you can maintain associations over time, through outages, reboots, etc
[ -z "${AGENT_UUID}" ] || echo -n "${AGENT_UUID}" > /var/lib/cloudera-scm-agent/uuid

## Assign config values from env, or use defaults
AGENT_DIR=${AGENT_DIR:-/var/run/cloudera-scm-agent}
LIB_DIR=${LIB_DIR:-/var/lib/cloudera-scm-agent}
LISTENING_PORT=${PORT0:-9000}
LOGDIR=${LOGDIR:-/var/log/cloudera-scm-agent}
LOGFILE=${LOG_DIR:--}
PACKAGE_DIR=${PACKAGE_DIR:-/usr/lib64/cmf/service}
REPORTED_HOSTNAME=${REPORTED_HOSTNAME:-${HOST}}
SERVER_HOST=${SERVER_HOST:-localhost}
SERVER_PORT=${SERVER_PORT:-7182}
SUPERVISORD_PORT=${PORT1:-19001}

## Write out config file
cat > /etc/cloudera-scm-agent/config.ini << EOF
[General]
listening_port=${LISTENING_PORT}
reported_hostname=${REPORTED_HOSTNAME}
server_host=${SERVER_HOST}
server_port=${SERVER_PORT}
supervisord_port=${SUPERVISORD_PORT}
EOF

## Log config and env for troubleshooting
cat 1>&2 << EOF
config:
$(cat /etc/cloudera-scm-agent/config.ini)

env:
$(env)
EOF

## Finally, exec to cm-agent
exec /usr/lib64/cmf/agent/build/env/bin/python /usr/lib64/cmf/agent/build/env/bin/cmf-agent \
  --agent_dir=${AGENT_DIR} \
  --lib_dir=${LIB_DIR} \
  --logdir=${LOGDIR} \
  --logfile=${LOGFILE} \
  --package_dir=${PACKAGE_DIR}
