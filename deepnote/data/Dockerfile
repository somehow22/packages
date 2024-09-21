ARG FROM_PYTHON_VERSION=3.11
ARG DEBIAN_VERSION=bookworm
FROM python:${FROM_PYTHON_VERSION}-slim-${DEBIAN_VERSION}
ENV DEBIAN_FRONTEND noninteractive

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

# Set up PATH
ENV PATH="/root/work/bin:${PATH}"

# Set working directory
WORKDIR /root/work

RUN python -m venv --system-site-packages ~/venv

ENV SHELL=/bin/bash \
  LC_ALL=en_US.UTF-8 \
  LANG=en_US.UTF-8 \
  LANGUAGE=en_US.UTF-8

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
  locale-gen

# Copy requirements.txt and install Python dependencies
COPY requirements.txt .
RUN . venv/bin/activate && pip install -r requirements.txt

# Activate virtual environment in bash
RUN echo "source /root/work/venv/bin/activate" >> ~/.bashrc
