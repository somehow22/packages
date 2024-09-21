ARG FROM_PYTHON_VERSION=3.11
ARG DEBIAN_VERSION=bookworm
FROM python:${FROM_PYTHON_VERSION}-slim-${DEBIAN_VERSION}
ENV DEBIAN_FRONTEND=noninteractive

# Switch to root user
USER root

# Install system dependencies
RUN apt-get update &&  apt-get -yq dist-upgrade \
    && apt-get install -yq --no-install-recommends \
    vim \
    screen \
    cmake curl git \
    locales sudo unzip \
    ssh gnupg2 \
    lsof \
    netcat-openbsd \
    mtr-tiny \
    zsh \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create necessary directories
RUN mkdir -p /root/work/bin

# Download and install Syncthing
RUN SYNCTHING_VERSION=$(curl -s https://api.github.com/repos/syncthing/syncthing/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")') && \
    wget https://github.com/syncthing/syncthing/releases/download/${SYNCTHING_VERSION}/syncthing-linux-amd64-${SYNCTHING_VERSION}.tar.gz -O syncthing.tar.gz && \
    tar -xzf syncthing.tar.gz && \
    mv syncthing-linux-amd64-${SYNCTHING_VERSION}/syncthing /root/work/bin/ && \
    rm -rf syncthing-linux-amd64-${SYNCTHING_VERSION} syncthing.tar.gz

# Install Bun
RUN curl -fsSL https://bun.sh/install | bash \
    && mv /root/.bun /root/work/bun

# Set up PATH
ENV PATH="/root/work/bin:/root/work/bun/bin:${PATH}"

# Set working directory
WORKDIR /root/work

# Install HAProxy
RUN apt-get update && \
    apt-get install -y gnupg2 curl && \
    curl https://haproxy.debian.net/bernat.debian.org.gpg | apt-key add - && \
    echo "deb http://haproxy.debian.net bookworm-backports-3.0 main" > /etc/apt/sources.list.d/haproxy.list && \
    apt-get update && \
    apt-get install -y haproxy && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set up Python virtual environment
RUN python -m venv venv \
    && . venv/bin/activate \
    && rm -rf ~/.cache/pip

# Copy and install base packages
COPY ../basepkgs.txt .
RUN . venv/bin/activate && pip install -r basepkgs.txt && rm basepkgs.txt

# Copy and install image-specific requirements
COPY requirements.txt .
RUN . venv/bin/activate && pip install -r requirements.txt && rm requirements.txt

ENV SHELL=/bin/bash
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
  locale-gen

ENV VIRTUAL_ENV=/root/work/venv
ENV PATH="/root/work/bin:$VIRTUAL_ENV/bin:${PATH}"

SHELL ["/bin/bash", "-c"]

# Activate virtual environment in bash
RUN echo "source /root/work/venv/bin/activate" >> ~/.bashrc

CMD ["/bin/bash"]