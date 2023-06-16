FROM alpine:3.17

RUN set -x \
  && apk --no-cache add bash curl libc6-compat logrotate ssmtp \
  ;

# Install go-crond
RUN set -x \
  && GO_CROND_VERSION=23.2.0 \
  && GO_CROND_CHECKSUM_X86_64=24a37df2e0f7a3c77d14e31cb19c1951573bfd9307152063f7a3f32666085f41 \
  && GO_CROND_CHECKSUM_AARCH64=5b4682a9795e27632aab00b87a2590a86672ce600bd4e5a9da733beabc80bc74 \
  && if [ "$(uname -m)" = "x86_64" ] ; then \
        GO_CROND_CHECKSUM="${GO_CROND_CHECKSUM_X86_64}"; \
        GO_CROND_ARCH="amd64"; \
      elif [ "$(uname -m)" = "aarch64" ]; then \
        GO_CROND_CHECKSUM="${GO_CROND_CHECKSUM_AARCH64}"; \
        GO_CROND_ARCH="arm64"; \
      fi \
  && curl -L -sSf -o /tmp/go-crond.linux.${GO_CROND_ARCH} https://github.com/webdevops/go-crond/releases/download/${GO_CROND_VERSION}/go-crond.linux.${GO_CROND_ARCH} \
  && printf '%s  %s\n' "${GO_CROND_CHECKSUM}" "go-crond.linux.${GO_CROND_ARCH}" > /tmp/SHA256SUM \
  && ( cd /tmp; sha256sum -c SHA256SUM || ( echo "Expected $(sha256sum go-crond.linux.${GO_CROND_ARCH})"; exit 1; )) \
  && install -m 0755 /tmp/go-crond.linux.${GO_CROND_ARCH} /usr/local/bin/go-crond \
  && rm -rf /tmp/* \
  ;

COPY *.sh /
RUN for item in /*.sh; do ln -s ${item} /${item%.*}; chmod +x ${item}; done

ENTRYPOINT ["/entry.sh"]
CMD ["/usr/local/bin/go-crond", "--allow-unprivileged", "/crontab"]
