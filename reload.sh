#!/usr/bin/env bash

# Fail on errors
set -e
[ "${DEBUG:-false}" == 'true' ] && set -x

# Reload crontab
kill -HUP 1
