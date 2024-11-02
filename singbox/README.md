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
