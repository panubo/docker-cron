# Docker Cron

Cron in a container.

## Configuration

Mount the crontab at `/crontab`. The cron jobs will be run with the underprivileged `cron` user.

NB. The container will need to be restarted if the crontab is changed or exec `/reload.sh`.

Configure timezone with `TZ` environment variable. eg: `-e TZ=Australia/Sydney`
or use `CRON_TZ` for each crontab line.

For linking to SMTP container (optional):

- `SMTP_HOST`
- `SMTP_PORT`
- `SMTP_USER`
- `SMTP_PASS`

Cron Email settings (optional):

 - `EMAIL_FROM`
 - `EMAIL_TO`
 - `HOSTNAME`

## Example

Example with timezone set:

`docker run --rm -t -i -v $(pwd)/crontab:/crontab -e TZ=Australia/Sydney panubo/cron`

## History

- v1.x - Debian based
- v2.x - Alpine Linux with [go-crond](https://github.com/webdevops/go-crond/), also includes additional tooling eg logrotate.

## Status

Production ready.
