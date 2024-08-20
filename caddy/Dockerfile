FROM caddy:2.8.4-builder-alpine AS builder
RUN xcaddy build  \
  --with github.com/mholt/caddy-events-exec \
  --with github.com/mholt/caddy-l4 \
  --with github.com/mholt/caddy-ratelimit \
  --with github.com/caddyserver/cache-handler

FROM caddy:2-alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 80 443 2019
VOLUME /config
WORKDIR /srv

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
