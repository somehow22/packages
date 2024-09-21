FROM bitnami/python:3.11-debian-12

# Switch to root user
USER root

# Install system dependencies
RUN apt-get update && apt-get install -y \
    vim \
    screen \
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

# Set up Python virtual environment
RUN python -m venv venv \
    && . venv/bin/activate \
    && rm -rf ~/.cache/pip
ENV PATH="/root/work/venv/bin:${PATH}"

# Copy requirements.txt and install Python dependencies
COPY requirements.txt /root/work/
RUN . /root/work/venv/bin/activate && pip install -r /root/work/requirements.txt
WORKDIR /root/work

# Set default shell to zsh
SHELL ["/bin/bash", "-c"]

# Activate virtual environment in zsh
RUN echo "source /root/work/venv/bin/activate" >> ~/.bashrc

CMD ["/bin/bash"]
