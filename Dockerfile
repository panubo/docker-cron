FROM debian:stretch

RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get install -y busybox-syslogd cron curl locales ssmtp supervisor \
  && adduser --system --no-create-home cron \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  ;

RUN CURLTAB_VERSION=0.0.1 \
  && mkdir -p /opt/bin \
  && curl -L https://github.com/panubo/curltab/releases/download/0.0.1/curltab-0.0.1-linux-amd64.tar.gz | tar -C /opt/bin -zxf -

COPY supervisord.conf /etc/supervisord.conf
COPY *.sh /
RUN for item in /*.sh; do ln -s ${item} /${item%.*}; chmod +x ${item}; done

ENTRYPOINT ["/entry.sh"]
CMD ["supervisord", "-n", "-c", "/etc/supervisord.conf"]
