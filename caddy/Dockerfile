# Update 241004
FROM --platform=$BUILDPLATFORM caddy:2.10.0-builder-alpine AS builder

ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM"

# Set GOARCH based on target platform
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

FROM --platform=$TARGETPLATFORM caddy:2-alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 80 443 2019
VOLUME /config
WORKDIR /srv

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
