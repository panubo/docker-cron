FROM alpine:3.17

RUN set -x \
  && apk --no-cache add bash curl libc6-compat logrotate ssmtp \
  ;

# Install Curltab
RUN set -x \
  && CURLTAB_VERSION=0.0.1 \
  && CURLTAB_CHECKSUM=6428a534e460078f62271f27da40d195bc028ab3f25322f2860080ce900d79a3 \
  && curl -L -sSf -o /tmp/curltab-linux-amd64.tar.gz https://github.com/panubo/curltab/releases/download/${CURLTAB_VERSION}/curltab-${CURLTAB_VERSION}-linux-amd64.tar.gz \
  && printf '%s  %s\n' "${CURLTAB_CHECKSUM}" "curltab-linux-amd64.tar.gz" > /tmp/SHA256SUM \
  && ( cd /tmp; sha256sum -c SHA256SUM || ( echo "Expected $(sha256sum curltab-linux-amd64.tar.gz)"; exit 1; )) \
  && tar -xzf /tmp/curltab-linux-amd64.tar.gz -C /tmp \
  && install -p -o root -g root -m 755 /tmp/curltab /usr/local/bin/ \
  && rm -rf /tmp/* \
  ;

# Install go-crond
RUN set -x \
  && GO_CROND_VERSION=23.2.0 \
  && GO_CROND_CHECKSUM=24a37df2e0f7a3c77d14e31cb19c1951573bfd9307152063f7a3f32666085f41 \
  && curl -L -sSf -o /tmp/go-crond.linux.amd64 https://github.com/webdevops/go-crond/releases/download/${GO_CROND_VERSION}/go-crond.linux.amd64 \
  && printf '%s  %s\n' "${GO_CROND_CHECKSUM}" "go-crond.linux.amd64" > /tmp/SHA256SUM \
  && ( cd /tmp; sha256sum -c SHA256SUM || ( echo "Expected $(sha256sum go-crond.linux.amd64)"; exit 1; )) \
  && mv /tmp/go-crond.linux.amd64 /usr/local/bin/go-crond \
  && chmod +x /usr/local/bin/go-crond \
  && rm -rf /tmp/* \
  ;

COPY *.sh /
RUN for item in /*.sh; do ln -s ${item} /${item%.*}; chmod +x ${item}; done

ENTRYPOINT ["/entry.sh"]
CMD ["/usr/local/bin/go-crond", "--allow-unprivileged", "/crontab"]
