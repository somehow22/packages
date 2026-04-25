# Agent Instructions

## Scope

This repository builds public GHCR images for selected custom packages.

Current maintained images:

- `caddy`
- `katbin`
- `singbox`

Do not update `deepnote` unless the user explicitly asks for it.

## Identity And Public Repo Hygiene

- Use the public GitHub identity for commits in this repository:
  - `So Jens <149686101+somehow22@users.noreply.github.com>`
- Do not commit private email addresses, credentials, service tokens, real SMTP settings, private hostnames, or project-specific runtime config.
- Keep image examples generic. Do not include Hyperjump-specific, private-network, or personal deployment details.
- Treat generated tarballs, exported Docker images, and workflow artifacts as potentially sensitive. Do not add them to Git.

## Image Conventions

- Publish to `ghcr.io/${{ github.repository_owner }}/<image>`.
- Keep image contexts, Dockerfiles, and platform lists in `.github/image-builds.json`.
- Treat `linux/arm64` as the Apple Silicon Docker target; only add it to images that need a Mac/ARM build.
- Caddy tags: `latest`, major version, exact Caddy version.
- Katbin tags: `latest`, commit SHA.
- sing-box tags: `<version>-v2ray-api`, `<version>-v2ray-api-<sha>`, and `latest-v2ray-api` for latest builds.
- Do not publish plain `singbox:latest` from the v2ray-API build unless the user explicitly changes that policy.

## Workflows

- `CI` builds the configured images and platforms without pushing.
- `Release Images` is the production publishing path and requires manual dispatch.
- `Upstream Updates` runs daily and opens a PR when Caddy, sing-box, or the Katbin submodule has moved upstream.

## Validation

Before pushing public changes:

- Run Docker build checks for changed images where practical.
- Scan tracked files and Git history for credentials and private identity leaks.
- Keep unrelated local files, especially untracked deployment examples, out of commits unless requested.
