FROM --platform=$BUILDPLATFORM golang:1.25-trixie AS builder

ARG SING_BOX_VERSION=v1.13.11
ARG TARGETOS
ARG TARGETARCH

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates git build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 --branch "${SING_BOX_VERSION}" https://github.com/SagerNet/sing-box.git /src

WORKDIR /src

ENV CGO_ENABLED=0
ENV GOOS=$TARGETOS
ENV GOARCH=$TARGETARCH

RUN set -eux; \
    VERSION="$(go run ./cmd/internal/read_tag)"; \
    TAGS="$(cat release/DEFAULT_BUILD_TAGS_OTHERS),with_v2ray_api"; \
    LDFLAGS_SHARED="$(cat release/LDFLAGS)"; \
    go build -v -trimpath -tags "$TAGS" \
      -o /go/bin/sing-box \
      -ldflags "-X \"github.com/sagernet/sing-box/constant.Version=$VERSION\" $LDFLAGS_SHARED -s -w -buildid=" \
      ./cmd/sing-box

FROM debian:trixie-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates iproute2 nftables tzdata \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /go/bin/sing-box /usr/local/bin/sing-box

ENTRYPOINT ["sing-box"]
