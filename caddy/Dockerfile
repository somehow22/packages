ARG CADDY_VERSION=2.10.2

FROM --platform=$BUILDPLATFORM caddy:${CADDY_VERSION}-builder-alpine AS builder

ARG TARGETOS TARGETARCH
ENV GOOS=$TARGETOS GOARCH=$TARGETARCH

RUN xcaddy build \
  --with github.com/caddy-dns/cloudflare \
  --with github.com/WeidiDeng/caddy-cloudflare-ip \
  --with github.com/mholt/caddy-events-exec \
  --with github.com/mholt/caddy-l4 \
  --with github.com/mholt/caddy-ratelimit \
  --with github.com/caddyserver/cache-handler

# Runtime (non-root)
FROM --platform=$TARGETPLATFORM caddy:${CADDY_VERSION}-alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

# Prepare writable dirs for non-root at build time
RUN mkdir -p /data /config /srv \
    && addgroup -S caddy 2>/dev/null || true \
    && adduser -S -D -H -s /sbin/nologin -G caddy -u 65532 caddy || true \
    && chown -R 65532:65532 /data /config /srv

USER 65532:65532
WORKDIR /srv
EXPOSE 18080 18443

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
