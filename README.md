# Docker Cron

[![build and push on main and tags](https://github.com/panubo/docker-cron/actions/workflows/build-push.yml/badge.svg)](https://github.com/panubo/docker-cron/actions/workflows/build-push.yml)

Cron in a container, based on Alpine Linux and [go-crond](https://github.com/webdevops/go-crond).

This image is publicly available from:
- **Quay.io:** `quay.io/panubo/cron`
- **AWS ECR Public:** `public.ecr.aws/panubo/cron`

## Features

- **Unprivileged Cron:** Cron jobs run as a non-root `cron` user.
- **Lightweight:** Based on Alpine Linux.
- **Flexible Logging:** `go-crond` logs to stdout/stderr, making it easy to integrate with container logging systems.
- **Mail Support:** Send cron output via email using `ssmtp`.
- **Dynamic Reloading:** Crontabs can be reloaded without restarting the container.

## Usage

### Basic Example

To run a simple cron job, you need to mount a crontab file at `/crontab`.

`crontab` file:
```crontab
# Run every minute
* * * * * echo "Hello from cron!"
```

Run the container:
```sh
docker run --rm \
  -v $(pwd)/crontab:/crontab \
  quay.io/panubo/cron
```

### Docker Compose Example

For a more persistent setup, use `docker-compose`:

```yaml
services:
  cron:
    image: quay.io/panubo/cron
    container_name: my-cron-service
    restart: unless-stopped
    volumes:
      - ./crontab:/crontab
    environment:
      - TZ=Australia/Sydney
      - EMAIL_TO=your-email@example.com
      # SMTP settings if you want email notifications
      # - SMTP_HOST=smtp.example.com
      # - SMTP_PORT=587
      # - SMTP_USER=user
      # - SMTP_PASS=password
      # - EMAIL_FROM=cron@example.com
```

### Reloading Crontab

If you update the `/crontab` file, you can reload it without restarting the container by executing the `/reload.sh` script:

```sh
docker exec my-cron-service /reload.sh
```

## Configuration

Configuration is managed through environment variables.

| Variable      | Description                                                                        | Default         |
|---------------|------------------------------------------------------------------------------------|-----------------|
| `TZ`          | Sets the container's timezone (e.g., `Australia/Sydney`).                          | `UTC`           |
| `CRON_TZ`     | Sets the timezone for individual cron jobs in the crontab file.                    | -               |
| `EMAIL_FROM`  | The `From:` address for cron emails.                                               | `cron`          |
| `EMAIL_TO`    | The `To:` address for cron emails.                                                 | `cron`          |
| `SMTP_HOST`   | The SMTP server host.                                                              | `localhost`     |
| `SMTP_PORT`   | The SMTP server port.                                                              | `25`            |
| `SMTP_USER`   | Username for SMTP authentication.                                                  | `''`            |
| `SMTP_PASS`   | Password for SMTP authentication.                                                  | `''`            |
| `HOSTNAME`    | Hostname to use for email headers.                                                 | container host  |
| `DEBUG`       | Set to `true` to enable verbose script execution (`set -x`).                       | `false`         |

## Building from Source

To build the image locally, you can use the provided `Makefile`:

```sh
make build
```

## History

- **v1.x:** Debian-based, using standard `vixie-cron`.
- **v2.x:** Migrated to Alpine Linux with [go-crond](https://github.com/webdevops/go-crond) for better container integration. Also includes additional tooling like `logrotate` and `ssmtp`.

## Status

Production ready.
