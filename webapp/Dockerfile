FROM ubuntu:22.04

# Install netcat (using openbsd version)
RUN apt-get update && \
    apt-get install -y netcat-openbsd && \
    rm -rf /var/lib/apt/lists/*

# Expose the port netcat will listen on
EXPOSE 8080

# Simple loop to serve a static HTTP response on port 8080
CMD while true; do { echo -e "HTTP/1.1 200 OK\r\nContent-Length: 26\r\nContent-Type: text/plain\r\n\r\nHello from Netcat Webapp!"; } | nc -l -p 8080 -q 1; done
