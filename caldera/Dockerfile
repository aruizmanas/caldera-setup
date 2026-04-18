FROM node:20-slim

# We need curl to get Go, and python3 for Caldera core
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-dev \
    curl \
    git \
    gcc \
    ca-certificates \
    vim \
    make \
    net-tools \
    haproxy \
    && rm -rf /var/lib/apt/lists/*

# 2. Install Go 1.26.2 manually
# This downloads the binary, extracts it to /usr/local, and cleans up the tarball
RUN curl -fsSL https://go.dev/dl/go1.26.2.linux-amd64.tar.gz | tar -C /usr/local -xz
# Must be exactly this to satisfy the app_svc check
ENV PATH="/usr/local/go/bin:${PATH}"

# Set the working directory
WORKDIR /usr/src/app

# Clone the Caldera repository
RUN git clone --recursive https://github.com/mitre/caldera.git . && \
    pip3 install --break-system-packages --no-cache-dir -r requirements.txt \
    docker selenium pyautogui beautifulsoup4 donut-shellcode webdriver_manager && \
    cd plugins/magma && npm install && npm run build

# Expose the ports: 8888 (UI), 7010 (TCP agent), 7011 (UDP agent), 7012 (Websocket Agent Contact)
EXPOSE 8888 7010 7011 7012

# Run Caldera with the --build flag to compile the UI (Magma plugin)
CMD [ "python3", "server.py", "--build", "--log", "DEBUG" ]
