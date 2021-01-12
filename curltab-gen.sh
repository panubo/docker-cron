#!/usr/bin/env bash

# Fail on errors
set -e
[ "${DEBUG:-false}" == 'true' ] && set -x

if [[ -e "/curltab.env" ]]; then
  CURLTAB_OPTS="${CURLTAB_OPTS} -e /curltab.env"
fi

curltab gen ${CURLTAB_OPTS} | tee /crontab
