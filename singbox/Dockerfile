# Build stage
FROM --platform=$BUILDPLATFORM golang:1.23-bookworm AS builder

WORKDIR /go/src/github.com/sagernet/sing-box

# Arguments for version
ARG SINGBOX_VERSION

# Download and extract the source tarball
RUN curl -L https://github.com/SagerNet/sing-box/archive/refs/tags/v${SINGBOX_VERSION}.tar.gz | tar xz --strip-components=1

# Build sing-box
ARG TARGETOS TARGETARCH
ARG GOPROXY=""
ENV GOPROXY=${GOPROXY}
ENV CGO_ENABLED=0
ENV GOOS=${TARGETOS}
ENV GOARCH=${TARGETARCH}
RUN go build -v -trimpath -tags \
    "with_gvisor,with_quic,with_dhcp,with_wireguard,with_ech,with_utls,with_reality_server,with_acme,with_clash_api" \
    -o /go/bin/sing-box \
    -ldflags "-X \"github.com/sagernet/sing-box/constant.Version=v${SINGBOX_VERSION}\" -s -w -buildid=" \
    ./cmd/sing-box

# Final stage
FROM debian:bookworm-slim

# Install minimal runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    nftables \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy the sing-box binary from the builder stage
COPY --from=builder /go/bin/sing-box /usr/local/bin/sing-box

# Download the kernel module build script
RUN curl -fsSL https://tcp.hy2.sh/ -o /usr/local/bin/build_kernel_module.sh \
    && chmod +x /usr/local/bin/build_kernel_module.sh

# Set the entrypoint
ENTRYPOINT ["sing-box"]
