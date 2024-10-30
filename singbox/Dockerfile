# Build stage for sing-box and tcp-brutal
FROM --platform=$BUILDPLATFORM golang:1.23-bookworm AS builder

WORKDIR /go/src/github.com/sagernet/sing-box

# Arguments for version
ARG SINGBOX_VERSION

# Install necessary build tools and kernel headers
RUN apt-get update && apt-get install -y \
    build-essential \
    linux-headers-generic \
    kmod \
    dkms \
    && rm -rf /var/lib/apt/lists/*

# Download and extract the sing-box source tarball
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

# Build tcp-brutal
WORKDIR /tcp-brutal
RUN curl -L https://github.com/apernet/tcp-brutal/archive/refs/heads/master.tar.gz | tar xz --strip-components=1
# Modify Makefile to ensure TCP congestion control support
RUN sed -i 's/ccflags-y := -std=gnu99/ccflags-y := -std=gnu99 -DCONFIG_TCP_CONG_BBR -DCONFIG_TCP_CONG_CUBIC -DCONFIG_IPV6=y/' Makefile && \
    KERNELDIR=/usr/src/linux-headers-$(ls -1 /lib/modules | tail -n 1) \
    KCFLAGS="-DCONFIG_TCP_CONG_BBR -DCONFIG_TCP_CONG_CUBIC -DCONFIG_IPV6=y" make

# Final stage
FROM debian:bookworm-slim

# Install runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    nftables \
    kmod \
    linux-modules-extra-$(uname -r) \
    && rm -rf /var/lib/apt/lists/*

# Copy the sing-box binary from the builder stage
COPY --from=builder /go/bin/sing-box /usr/local/bin/sing-box

# Copy the tcp-brutal kernel module from the builder stage
COPY --from=builder /tcp-brutal/brutal.ko /usr/lib/modules/

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]
