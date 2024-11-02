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
        bash

# Define variables for versions
ENV TCP_BRUTAL_REPO="https://github.com/apernet/tcp-brutal"
ENV SINGBOX_VERSION="latest"

# Fetch the latest release version of tcp-brutal
RUN TCP_BRUTAL_VERSION=$(curl -s https://api.github.com/repos/apernet/tcp-brutal/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")') && \
    echo "Latest tcp-brutal version: $TCP_BRUTAL_VERSION" && \
    echo "TCP_BRUTAL_VERSION=${TCP_BRUTAL_VERSION#v}" >> /etc/environment

# Download and extract the latest tcp-brutal release tarball
RUN mkdir -p /usr/src/tcp-brutal && \
    curl -L "https://github.com/apernet/tcp-brutal/archive/refs/tags/${TCP_BRUTAL_VERSION}.tar.gz" | tar xz --strip-components=1 -C /usr/src/tcp-brutal

# Copy and update AKMBUILD file
COPY AKMBUILD /usr/src/tcp-brutal/
RUN sed -i "s/modver=\".*\"/modver=\"${TCP_BRUTAL_VERSION#v}\"/" /usr/src/tcp-brutal/AKMBUILD

# Navigate to the tcp-brutal directory and build the module
RUN cd /usr/src/tcp-brutal && \
    akms install all && \
    echo "Built tcp-brutal module for Sing-box version ${SINGBOX_VERSION}"

# Clean up unnecessary files to reduce image size
RUN apk del alpine-sdk linux-lts-dev

# Use the base image's ENTRYPOINT
