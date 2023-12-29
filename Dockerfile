FROM alpine:3.19

RUN set -x \
  && apk --no-cache add bash curl libc6-compat logrotate ssmtp \
  ;

# Install go-crond
RUN set -x \
  && GO_CROND_VERSION=23.12.0 \
  && GO_CROND_CHECKSUM_X86_64=15f3f4cd76d6fbe397eec0ddd3f3f8589d7a98da57e6f5ff54852dec6a49badd \
  && GO_CROND_CHECKSUM_AARCH64=361d5ff5601e5779339be3d0bbdcb878642af6b65feb69b5d3182b72e9cd1c35 \
  && if [ "$(uname -m)" = "x86_64" ] ; then \
        GO_CROND_CHECKSUM="${GO_CROND_CHECKSUM_X86_64}"; \
        GO_CROND_ARCH="amd64"; \
      elif [ "$(uname -m)" = "aarch64" ]; then \
        GO_CROND_CHECKSUM="${GO_CROND_CHECKSUM_AARCH64}"; \
        GO_CROND_ARCH="arm64"; \
      fi \
  && curl -L -sSf -o /tmp/go-crond.linux.${GO_CROND_ARCH} https://github.com/webdevops/go-crond/releases/download/${GO_CROND_VERSION}/go-crond.linux.${GO_CROND_ARCH} \
  && printf '%s  %s\n' "${GO_CROND_CHECKSUM}" "go-crond.linux.${GO_CROND_ARCH}" > /tmp/SHA256SUM \
  && cat /tmp/SHA256SUM \
  && echo --------------------------\
  && ( cd /tmp; sha256sum -c SHA256SUM || ( echo "Expected $(sha256sum go-crond.linux.${GO_CROND_ARCH})"; exit 1; )) \
  && install -m 0755 /tmp/go-crond.linux.${GO_CROND_ARCH} /usr/local/bin/go-crond \
  && rm -rf /tmp/* \
  ;

COPY *.sh /
RUN for item in /*.sh; do ln -s ${item} /${item%.*}; chmod +x ${item}; done

ENTRYPOINT ["/entry.sh"]
CMD ["/usr/local/bin/go-crond", "--allow-unprivileged", "/crontab"]
