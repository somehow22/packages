ARG CADDY_VERSION=2.11.3

FROM --platform=$BUILDPLATFORM caddy:${CADDY_VERSION}-builder-alpine AS builder

ARG TARGETOS TARGETARCH
ENV GOOS=$TARGETOS GOARCH=$TARGETARCH

RUN mkdir -p /empty

RUN xcaddy build \
  --with github.com/caddy-dns/cloudflare \
  --with github.com/mholt/caddy-l4 \
  --with github.com/mholt/caddy-ratelimit \
  --with github.com/caddyserver/cache-handler

RUN setcap -r /usr/bin/caddy || true

# Runtime (distroless, non-root)
FROM gcr.io/distroless/static-debian12:nonroot

ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

COPY --from=builder --chown=65532:65532 /empty/ /config/
COPY --from=builder --chown=65532:65532 /empty/ /data/
COPY --from=builder --chown=65532:65532 /empty/ /srv/
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

USER 65532:65532
WORKDIR /srv
EXPOSE 18080 18443

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
