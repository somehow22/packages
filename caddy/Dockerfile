ARG CADDY_VERSION=2.10.2

FROM --platform=$BUILDPLATFORM caddy:${CADDY_VERSION}-builder-alpine AS builder

ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM"

# Set GOOS/GOARCH based on target platform
ARG TARGETOS
ARG TARGETARCH
ENV GOOS=$TARGETOS
ENV GOARCH=$TARGETARCH

RUN xcaddy build \
  --with github.com/caddy-dns/cloudflare \
  --with github.com/WeidiDeng/caddy-cloudflare-ip \
  --with github.com/mholt/caddy-events-exec \
  --with github.com/mholt/caddy-l4 \
  --with github.com/mholt/caddy-ratelimit \
  --with github.com/caddyserver/cache-handler

FROM --platform=$TARGETPLATFORM caddy:${CADDY_VERSION}-alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

# Minimal helper to drop privileges after fixing volume ownership
RUN apk add --no-cache su-exec
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

USER root
EXPOSE 80 443 8080
VOLUME /config
WORKDIR /srv

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
