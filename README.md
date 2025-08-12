# brainxio/openwebui

## Overview
This repository contains the configuration and documentation for deploying OpenWebUI (OUI), a platform for smart chat agents. It includes modular Docker Compose setups with overrides for Tailscale, Traefik, ports, and volumes.

## Quick Start
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/brainxio/openwebui.git
   cd openwebui
   ```
2. **Set Up Environment**:
   - Copy `.env.example` to `.env` and configure: `DOMAIN=yourdomain.com`, `IP_WHITELIST=your_ip/32`, `TSAUTHKEY_PATH=~/.secrets/openwebui-tsauthkey.key` (if needed).
3. **Launch the Stack**:
   - Base: `docker compose up -d`.
   - Add Ports: `docker compose -f docker-compose.yml -f docker-compose.add.ports.yml up -d`.
   - Add Tailscale: `docker compose -f docker-compose.yml -f docker-compose.add.tailscale.yml up -d`.
   - Add Traefik: `docker compose -f docker-compose.yml -f docker-compose.add.traefik.yml up -d`.
   - Add Traefik-Tailscale: `docker compose -f docker-compose.yml -f docker-compose.add.traefik-tailscale.yml up -d`.
   - Add Volume: `docker compose -f docker-compose.yml -f docker-compose.add.volume.yml up -d`.
   - Add Traefik-Tailscale-Volume: `docker compose -f docker-compose.yml -f docker-compose.add.traefik-tailscale.yml -f docker-compose.add.volume.yml up -d`.
   - Check status: `docker compose ps`.
4. **Access**:
   - Local: `http://localhost:8080` (with ports).
   - Traefik: `http://chat.yourdomain.com`.
   - Tailscale: Use Tailscale IP.

## Directory Structure
```
.
├── docker-compose.yml          # Base OUI configuration
├── docker-compose.add.ports.yml    # Adds local port mapping
├── docker-compose.add.tailscale.yml # Adds Tailscale networking
├── docker-compose.add.traefik.yml   # Adds Traefik routing
├── docker-compose.add.traefik-tailscale.yml # Combines Traefik with Tailscale
├── docker-compose.add.volume.yml    # Switches to external volume
├── docs
│   ├── 01-agent-machine-hardware.markdown
│   ├── 02-base-model-selection.markdown
│   ├── 03-character-identity.markdown
│   ├── 04-functions.markdown
│   ├── 05-tools.markdown
│   └── 06-deployment.markdown
├── .env.example                # Environment variable template
├── .gitignore                  # Ignores sensitive files
├── local-deployment.sh         # Local setup script
└── LICENSE
```

## Features
- **Modular Overrides**: Combine Tailscale, Traefik, ports, or volumes as needed.
- **Flexibility**: Configurable for various deployment scenarios.

## Troubleshooting
- **Network Issues**: Check Traefik logs and ensure `traefik-net` is set up.
- **Tailscale Problems**: Verify auth key and network configuration.
- **Access Errors**: Ensure `.env` settings match your setup.

## Contributing
Fork the repository, make your changes, and submit a pull request. Open issues for bugs or feature ideas.

## License
[LICENSE] - See the file for details.