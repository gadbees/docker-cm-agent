#!/bin/sh

## AGENT_UUID is cm agent's identity in Cloudera Manager
## By using a consistent UUID, you can maintain associations over time, through outages, reboots, etc
[ -z "${AGENT_UUID}" ] || echo -n "${AGENT_UUID}" > /var/lib/cloudera-scm-agent/uuid

## Assign config values from env, or use defaults
SERVER_HOST=${SERVER_HOST:-localhost}
SERVER_PORT=${SERVER_PORT:-7182}
LISTENING_PORT=${PORT0:-9000}
REPORTED_HOSTNAME=${REPORTED_HOSTNAME:-${HOST}}
SUPERVISORD_PORT=${PORT1:-19001}

## Write out config file
cat > /etc/cloudera-scm-agent/config.ini << EOF
[General]
server_host=${SERVER_HOST}
server_port=${SERVER_PORT}
listening_port=${LISTENING_PORT}
reported_hostname=${REPORTED_HOSTNAME}
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
exec /usr/lib64/cmf/agent/build/env/bin/python /usr/lib64/cmf/agent/src/cmf/agent.py \
  --package_dir /usr/lib64/cmf/service \
  --agent_dir /var/run/cloudera-scm-agent \
  --lib_dir /var/lib/cloudera-scm-agent
