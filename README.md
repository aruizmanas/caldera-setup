# Caldera Adversary Emulation Lab

This repository provides a fully automated, containerized environment for **MITRE Caldera**, integrated with sample targets and virtualized environments for adversary emulation testing.

## Overview

The project streamlines the setup of a Caldera server along with a sample web application and dedicated target virtual machines (Ubuntu and Windows 10). It includes automated configuration generation for SSL, HAProxy, and Caldera's user management.

## Project Structure

- **`caldera/`**: Dockerfile for the Caldera server (includes Go 1.26.2 and Magma UI build).
- **`webapp/`**: A lightweight netcat-based web application for simple target testing.
- **`vboxes/`**: Vagrant configurations for realistic target environments.
  - `ubuntu/`: Minimal Ubuntu target.
  - `windows/`: Windows 10 target.
- **`scripts/`**: Utility scripts for environment preparation.
- **`outputs/`**: (Generated) Stores the resulting configuration, SSL certificates, and HAProxy settings.

## Prerequisites

- **Docker** and **Docker Compose**
- **Vagrant**
- **VirtualBox** (or another Vagrant-compatible provider)

## Getting Started

### 1. Initialize Configuration
Before starting the containers, run the setup script to generate the required SSL certificates and configuration files.
```bash
chmod +x scripts/setup_caldera.sh
./scripts/setup_caldera.sh
```
This generates `local.yml`, `haproxy.conf`, and `certificate.pem` in the `outputs/` directory.

### 2. Launch the Lab
Start the Caldera server and the sample web application using Docker Compose.
```bash
docker compose up -d
```
- **Caldera UI**: [https://localhost:8443](https://localhost:8443) (via SSL Plugin/HAProxy)
- **Sample Webapp**: [http://localhost:8080](http://localhost:8080)

### 3. Deploy Target VMs (Optional)
Navigate to the desired target directory and bring up the virtual machine.

#### Ubuntu Target
```bash
cd vboxes/ubuntu
vagrant up
```

#### Windows Target
```bash
cd vboxes/windows
vagrant up
```

## Configuration & Credentials

### Caldera Users
- **Red Admin**: `red` / `letmein`
- **Blue Admin**: `blue` / `letmein`

### Network Ports
| Service | Port | Description |
|---------|------|-------------|
| Caldera HTTPS | 8443 | Secure UI and Agent Contact |
| Webapp | 8080 | Sample target web server |
| TCP Agent | 7010 | TCP Contact Port |
| UDP Agent | 7011 | UDP Contact Port |
| WS Agent | 7012 | WebSocket Contact Port |
| SSH Contact | 2222 | SSH Agent Tunneling |
| DNS Contact | 8853 | DNS Agent Contact (UDP) |

## Features

- **Automated SSL**: Generates a self-signed 4096-bit RSA PEM file for the Caldera SSL plugin.
- **Modern UI**: Automatically builds the Magma plugin during the Docker build process.
- **Extensible Lab**: Easily add more targets by creating new directories in `vboxes/`.
- **Pre-configured Environment**: `local.yml` is pre-populated with necessary plugins (`ssl`, `manx`, `sandcat`) and API keys.
