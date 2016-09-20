FROM debian:latest

MAINTAINER andrew@panubo.com

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y busybox-syslogd cron curl ssmtp supervisor && \
    adduser --system --no-create-home cron && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY supervisord.conf /etc/supervisord.conf
COPY *.sh /

ENTRYPOINT ["/entry.sh"]
CMD ["supervisord", "-n", "-c", "/etc/supervisord.conf"]
