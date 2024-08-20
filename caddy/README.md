# Custom Caddy Server

This directory contains the configuration for a custom Caddy server build, part of the versatile package manager.

## Features

- Custom Caddy build with additional modules
- Automatic HTTPS
- HTTP/3 support
- Reverse proxy capabilities
- File server with directory browsing
- Customizable via Caddyfile

## Additional Modules

This custom Caddy build includes the following additional modules:

- github.com/mholt/caddy-events-exec
- github.com/mholt/caddy-l4
- github.com/mholt/caddy-ratelimit
- github.com/caddyserver/cache-handler
- github.com/caddy-dns/cloudflare
- github.com/WeidiDeng/caddy-cloudflare-ip

## Files

- `Dockerfile`: Defines the custom Caddy build
- `caddy/Caddyfile`: Caddyfile path when running from the `caddy/` directory
- `compose.yml`: Compose file for easy deployment

## Usage

1. Customize `caddy/caddy/Caddyfile` to your needs
2. Build and run with Docker Compose:
   - From repo root: `docker compose -f caddy/compose.yml up -d`
   - From `caddy/` dir: `docker compose up -d`
3. Health check endpoints:
   - Plain HTTP: `http://localhost:8080/health` (for probes)
   - HTTPS: `https://localhost/health` (cert-validation off in compose healthcheck)

## Kubernetes

- Admin API: disabled by default. Keep off in production. If needed, bind to localhost only and access via `kubectl exec`/`port-forward`.
- Health checks: use plain HTTP on port `8080` inside the Pod (not exposed via Service).
- Storage: `/data` (certs) and `/config` (autosave) stored on dedicated volumes; readable only by the Caddy process user.

Recommended spec highlights
- Main container securityContext:
  - runAsNonRoot: true
  - runAsUser: 65532
  - runAsGroup: 65532
  - allowPrivilegeEscalation: false
  - readOnlyRootFilesystem: true
  - capabilities: drop: ["ALL"]
- InitContainer (root) to prepare volumes:
  - image: `busybox:1.36`
  - command:
    - `sh -lc 'mkdir -p /data /config && chown -R 65532:65532 /data /config && chmod -R go-rwx /data /config && find /data /config -type d -exec chmod 0700 {} + && find /data /config -type f -exec chmod 0600 {} +'`
  - mounts: same `/data`, `/config` PVCs
- Probes (example):
  - readinessProbe: HTTP GET `/health` on port `8080`
  - livenessProbe: HTTP GET `/health` on port `8080`
- Service: expose only `80` and `443`; do not expose `8080`.

Image alignment between Docker and Kubernetes
- The image runs as UID/GID `65532`.
- Prepare `/data`, `/config`, and `/srv` ownership before startup when mounting persistent volumes.
- Compose uses the same non-root user as the image.

## Additional Resources

- [Official Caddy Documentation](https://caddyserver.com/docs/)
- [Caddyfile Syntax](https://caddyserver.com/docs/caddyfile)
- [Caddy Modules](https://caddyserver.com/docs/modules/)
