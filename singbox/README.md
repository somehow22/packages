# sing-box

This directory builds a generic sing-box image from upstream source with the v2ray API build tag enabled.

## Features

- Upstream sing-box default non-Android build tags.
- Additional `with_v2ray_api` build tag for V2Ray gRPC stats/API support.
- Debian trixie runtime with `ca-certificates`, `iproute2`, `nftables`, and `tzdata`.
- No project-specific config baked into the image.

## Tags

The workflow publishes v2ray-specific tags only:

- `ghcr.io/somehow22/singbox:<version>-v2ray-api`
- `ghcr.io/somehow22/singbox:<version>-v2ray-api-<sha>`
- `ghcr.io/somehow22/singbox:latest-v2ray-api`

It intentionally does not publish plain `latest`.

## Usage

Create a sing-box config under `./singbox-config/config.json`, then run:

```sh
docker compose up -d
```

## Configuration

sing-box uses JSON configuration. This image does not ship a default config.

For more details on configuring Sing-box, please refer to the official documentation: [Sing-box Configuration](https://sing-box.sagernet.org/configuration/)

## Building Locally

From the repository root:

```sh
docker buildx build --platform linux/amd64 -t singbox:v2ray-api ./singbox
```

For Apple Silicon Docker Desktop, build the Linux ARM64 image:

```sh
docker buildx build --platform linux/arm64 -t singbox:v2ray-api-arm64 --load ./singbox
```

## Handoff Note

This image is generic-purpose and does not include Hyperjump configuration.

See `HANDOFF.md` for the short note intended for downstream agents.

Build behavior:

- Clones upstream `SagerNet/sing-box` at `SING_BOX_VERSION`.
- Uses upstream `release/DEFAULT_BUILD_TAGS_OTHERS`.
- Adds `with_v2ray_api` so the binary exposes V2Ray API support.
- Publishes only v2ray-specific tags, for example `ghcr.io/somehow22/singbox:v1.13.11-v2ray-api` and `ghcr.io/somehow22/singbox:latest-v2ray-api`.

Hyperjump should provide its own sing-box JSON config at runtime and pull one of the `*-v2ray-api` tags instead of using a Hyperjump-specific image.
