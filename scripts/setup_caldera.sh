#!/bin/bash

# Function to generate local.yml configuration
generate_local_yml() {
    echo "Generating local.yml in outputs folder..."
    cat <<EOF > outputs/local.yml
ability_refresh: 60
client_max_size_mb: 1
api_upload_max_size_mb: 100
api_key_blue: BLUEADMIN123
api_key_red: ADMIN123
app.contact.dns.domain: mycaldera.caldera
app.contact.dns.socket: 0.0.0.0:8853
app.contact.ftp.host: 0.0.0.0
app.contact.ftp.port: 2222
app.contact.ftp.pword: caldera
app.contact.ftp.server.dir: ftp_dir
app.contact.ftp.user: caldera_user
app.contact.gist: API_KEY
app.contact.html: /weather
app.contact.http: http://0.0.0.0:8888
app.contact.slack.api_key: SLACK_TOKEN
app.contact.slack.bot_id: SLACK_BOT_ID
app.contact.slack.channel_id: SLACK_CHANNEL_ID
app.contact.tcp: 0.0.0.0:7010
app.contact.tunnel.ssh.host_key_file: REPLACE_WITH_KEY_FILE_PATH
app.contact.tunnel.ssh.host_key_passphrase: REPLACE_WITH_KEY_FILE_PASSPHRASE
app.contact.tunnel.ssh.socket: 0.0.0.0:8022
app.contact.tunnel.ssh.user_name: sandcat
app.contact.tunnel.ssh.user_password: s4ndc4t!
app.contact.udp: 0.0.0.0:7011
app.contact.websocket: 0.0.0.0:7012
auth.login.handler.module: default
crypt_salt: REPLACE_WITH_RANDOM_VALUE
encryption_key: ADMIN123
session_expiration_days: 7
exfil_dir: /tmp/caldera
host: 0.0.0.0
objects.planners.default: atomic
plugins:
- ssl
- manx
- sandcat
port: 8888
reachable_host_traits:
- remote.host.fqdn
- remote.host.ip
reports_dir: /tmp
requirements:
  go:
    command: go version
    type: installed_program
    version: 1.19
  python:
    attr: version
    module: sys
    type: python_module
    version: 3.9.0
users:
  blue:
    blue: admin
    password: letmein
  red:
    admin: admin
    password: letmein
    red: admin
EOF
}

# Function to generate a pem file for the ssl plugin
generate_pem() {
    echo "Generating certificate.pem in outputs folder..."
    # Using the command found in Caldera documentation
    # -subj "/CN=localhost" avoids interactive prompts
    openssl req -x509 -newkey rsa:4096 \
      -out outputs/certificate.pem \
      -keyout outputs/certificate.pem \
      -nodes -days 365 \
      -subj "/C=US/ST=State/L=City/O=Organization/OU=Unit/CN=localhost"
}

# Function to generate haproxy.conf for the ssl plugin
generate_haproxy_conf() {
    echo "Generating haproxy.conf in outputs folder..."
    cat <<EOF > outputs/haproxy.conf
global
    log /dev/log local0
    log /dev/log local1 notice
    stats timeout 30s
    daemon

defaults
    log global
    mode http
    option httplog
    option dontlognull
    timeout connect 5000
    timeout client  50000
    timeout server  50000

frontend caldera_frontend
    # Note: certificate.pem is expected in the same outputs directory
    bind *:8443 ssl crt /usr/src/app/plugins/ssl/conf/certificate.pem
    default_backend caldera_backend

backend caldera_backend
    balance roundrobin
    server caldera_main 127.0.0.1:8888 cookie caldera_main
EOF
}

# Main execution if script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    mkdir -p outputs
    generate_local_yml
    generate_pem
    generate_haproxy_conf
    chmod 644 outputs/*
    echo "Setup complete. Files are in the 'outputs' folder."
fi
