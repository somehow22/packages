# sing-box v2ray API Image Handoff

This repository publishes a generic sing-box image with v2ray API support. It is not tied to Hyperjump and does not include project config, private network values, credentials, or runtime defaults.

## Image

Use one of these tags:

```text
ghcr.io/somehow22/singbox:<version>-v2ray-api
ghcr.io/somehow22/singbox:<version>-v2ray-api-<repo-sha>
ghcr.io/somehow22/singbox:latest-v2ray-api
```

Do not depend on `ghcr.io/somehow22/singbox:latest`; this repo intentionally does not publish that tag for the v2ray API build.

## Build Method

The Dockerfile:

- starts from `golang:1.25-trixie`;
- clones `https://github.com/SagerNet/sing-box.git` at `SING_BOX_VERSION`;
- reads upstream `release/DEFAULT_BUILD_TAGS_OTHERS`;
- appends `with_v2ray_api`;
- builds `./cmd/sing-box`;
- copies the binary into a minimal Debian trixie runtime with `ca-certificates`, `iproute2`, `nftables`, and `tzdata`.

## Local Apple Silicon Build

Docker Desktop on Apple Silicon still runs Linux containers. Build the Linux ARM64 image:

```sh
docker buildx build --platform linux/arm64 -t singbox:v2ray-api-arm64 --load ./singbox
```

## Runtime Contract

Hyperjump should mount or generate its own sing-box JSON config at runtime. The image entrypoint is:

```text
sing-box
```

Pass normal sing-box commands and config paths from the deployment layer, for example:

```sh
docker run --rm -v "$PWD/config.json:/etc/sing-box/config.json:ro" ghcr.io/somehow22/singbox:latest-v2ray-api run -c /etc/sing-box/config.json
```
