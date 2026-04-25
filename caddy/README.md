# Custom Caddy Server

This directory contains the configuration for a custom Caddy server build, part of the versatile package manager.

## Features

- Custom Caddy build with additional modules
- Distroless non-root runtime image
- Automatic HTTPS
- HTTP/3 support
- Reverse proxy capabilities
- File server with directory browsing
- Customizable via Caddyfile

## Additional Modules

This custom Caddy build includes the following additional modules:

- `github.com/caddy-dns/cloudflare` for ACME DNS-01 with Cloudflare.
- `github.com/mholt/caddy-l4` for TCP/UDP layer 4 routing.
- `github.com/mholt/caddy-ratelimit` for HTTP rate limiting.
- `github.com/caddyserver/cache-handler` for HTTP response caching.

Removed modules:

- `github.com/WeidiDeng/caddy-cloudflare-ip`: redundant for this image. Caddy now has standard `trusted_proxies`, `client_ip_headers`, `client_ip`, and `{client_ip}` support. Use static trusted proxies or add a CDN range module only when a deployment needs dynamic CDN IP lists.
- `github.com/mholt/caddy-events-exec`: not used by the sample config, experimental, and expands the image's command-execution surface. Caddy's core `events` app remains available, but this image no longer ships the external `exec` event handler.

See `MODULES.md` for the current module audit.

## Client IP Behind Proxies

For private ingress, tunnels, or another reverse proxy in front of Caddy, prefer Caddy's built-in server options:

```caddyfile
{
    servers {
        trusted_proxies static private_ranges
        trusted_proxies_strict
        client_ip_headers X-Forwarded-For X-Real-IP Cf-Connecting-Ip
    }
}
```

For direct public Cloudflare proxy traffic, use explicit Cloudflare CIDRs or add a dedicated CDN range module in a future change. This image intentionally avoids baking a Cloudflare-specific IP range module.

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
   - Plain HTTP: `http://localhost/health` (for probes)
   - HTTPS: `https://localhost/health`

## Compose Hardening

The sample Compose service runs with:

- Non-root UID/GID `65532:65532`
- A distroless runtime image with no shell or package manager
- Read-only root filesystem
- Dropped Linux capabilities
- `no-new-privileges`
- Explicit writable volumes for `/data` and `/config`
- `nofile` ulimit for reverse-proxy workloads
- Rotated Docker logs and rotated Caddy file access logs

Because the runtime is distroless, the Compose healthcheck cannot use shell tools such as `wget`. It validates the loaded Caddyfile with the Caddy binary. Use the exposed `/health`, `/livez`, and `/readyz` endpoints from the host or an external monitor for end-to-end serving checks.

## Kubernetes

- Admin API: disabled by default. Keep off in production. If needed, bind to localhost only and access via `kubectl exec`/`port-forward`.
- Health checks: use plain HTTP on port `18080` inside the Pod.
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
  - readinessProbe: HTTP GET `/health` on port `18080`
  - livenessProbe: HTTP GET `/health` on port `18080`
- Service: expose only `80` and `443`.

Image alignment between Docker and Kubernetes
- The image runs as UID/GID `65532`.
- Prepare `/data`, `/config`, and `/srv` ownership before startup when mounting persistent volumes.
- Compose uses the same non-root user as the image.

## Additional Resources

- [Official Caddy Documentation](https://caddyserver.com/docs/)
- [Caddyfile Syntax](https://caddyserver.com/docs/caddyfile)
- [Caddy Modules](https://caddyserver.com/docs/modules/)
