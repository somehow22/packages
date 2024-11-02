FROM ghcr.io/sagernet/sing-box:latest

# Install necessary build dependencies
RUN apk update && apk upgrade && \
    apk add --no-cache \
        linux-lts-dev \
        alpine-sdk \
        akms \
        curl \
        tar \
        gzip \
        bash \
        jq && \
    KERNEL_VERSION=$(ls -1 /lib/modules/ | head -n 1) && \
    echo "KERNEL_VERSION=${KERNEL_VERSION}" >> /etc/environment

# Define variables for versions
ENV TCP_BRUTAL_REPO="https://github.com/apernet/tcp-brutal"
ENV SINGBOX_VERSION="latest"

# Fetch the latest release version and tarball URL of tcp-brutal
RUN TCP_BRUTAL_VERSION=$(curl -s https://api.github.com/repos/apernet/tcp-brutal/releases/latest | jq -r .tag_name) && \
    TARBALL_URL=$(curl -s https://api.github.com/repos/apernet/tcp-brutal/releases/latest | jq -r .tarball_url) && \
    echo "Latest tcp-brutal version: $TCP_BRUTAL_VERSION" && \
    TCP_BRUTAL_VERSION_CLEAN=${TCP_BRUTAL_VERSION#v} && \
    mkdir -p /usr/src/tcp-brutal && \
    curl -L "$TARBALL_URL" | tar xz --strip-components=1 -C /usr/src/tcp-brutal

# Copy and update AKMBUILD file
COPY AKMBUILD /usr/src/tcp-brutal/
RUN cd /usr/src/tcp-brutal && \
    sed -i "s/MODVER/$TCP_BRUTAL_VERSION_CLEAN/" AKMBUILD && \
    source /etc/environment && \
    KERNELVERSION=$KERNEL_VERSION akms install all && \
    echo "Built tcp-brutal module for Sing-box version ${SINGBOX_VERSION}"

# Clean up unnecessary files to reduce image size
RUN apk del alpine-sdk linux-lts-dev

# Use the base image's ENTRYPOINT
