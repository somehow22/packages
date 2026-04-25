# Caddy Module Audit

Audit date: 2026-04-25

The sample `caddy/caddy/Caddyfile` uses only standard Caddy directives. Extra modules are included for reusable image capability, not because the sample config requires them.

## Kept

| Module | Purpose | Decision |
| --- | --- | --- |
| `github.com/caddy-dns/cloudflare` | Cloudflare DNS provider for ACME DNS-01 and wildcard certificates. | Keep. Active `caddy-dns` module and not part of the standard Caddy image. Use a single scoped Cloudflare API token with `Zone.Zone:Read` and `Zone.DNS:Edit`. |
| `github.com/mholt/caddy-l4` | TCP/UDP layer 4 routing and protocol multiplexing. | Keep. Active and recently released, but still marked experimental by upstream. |
| `github.com/mholt/caddy-ratelimit` | HTTP request rate limiting. | Keep. Active, useful for edge protection, and not part of standard Caddy. |
| `github.com/caddyserver/cache-handler` | HTTP response cache based on Souin. | Keep. Official Caddy organization repository. Prefer this stable wrapper over direct `github.com/darkweak/souin/plugin/caddy` unless a new Souin feature is explicitly needed. |

## Removed

| Module | Reason |
| --- | --- |
| `github.com/WeidiDeng/caddy-cloudflare-ip` | Removed. Caddy core has `trusted_proxies`, `client_ip_headers`, `client_ip`, and `{client_ip}`. The public image should not bake a Cloudflare-only dynamic IP source unless a deployment specifically needs direct public Cloudflare CIDR tracking. |
| `github.com/mholt/caddy-events-exec` | Removed. Caddy core includes the `events` app, but this external handler executes system commands. It is experimental, has no releases, and is not used by the sample config. |

## Optional Future Additions

| Module | When to consider it |
| --- | --- |
| `github.com/sarumaj/caddy-cdn-ranges/v2` | If the image needs dynamic trusted proxy ranges for multiple CDN providers, including Cloudflare and CloudFront. This is broader than the removed Cloudflare-only module, but it is newer and should be added only with a concrete config/test case. |
| `github.com/fvbommel/caddy-combine-ip-ranges` | If a deployment needs to combine multiple trusted proxy IP sources, such as static private ranges plus a dynamic CDN source. |

## Built-In Caddy Coverage

The stock `caddy:2.11.2-alpine` image already includes:

- `events`
- `http.ip_sources.static`
- `http.matchers.client_ip`
- `{client_ip}` placeholder support
- `trusted_proxies`, `trusted_proxies_strict`, and `client_ip_headers` Caddyfile server options

Do not add a plugin when standard Caddy server options cover the deployment need.
