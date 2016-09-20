# Docker Cron

Cron in a container.

## Configuration

Mount the crontab at `/crontab`. NB The container will need to be restarted if the crontab is changed.

Configure timezone with `TZ` environment variable. eg: `-e TZ=Australia/Sydney`

For linking to SMTP container

- `SMTP_HOST`
- `SMTP_PORT`
- `SMTP_USER`
- `SMTP_PASS`

Cron Email settings:

 - `EMAIL_FROM`
 - `EMAIL_TO`
 - `HOSTNAME`

## Example

`docker run --rm -t -i -v /crontab:/crontab -e TZ=Australia/Sydney panubo/cron`
