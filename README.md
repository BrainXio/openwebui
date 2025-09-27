# brainxio/openwebui

## Overview
This repository provides a Docker Compose configuration for deploying OpenWebUI, a platform for smart chat agents. The setup is modular, using profiles to support local deployment, Traefik for HTTPS routing, and Tailscale for secure remote access. It aligns with the `brainxio/ollama` and `brainxio/n8n` projects for consistency and is accessible to users with minimal Docker experience.

### Services
- **openwebui-local**: Runs OpenWebUI with local port mapping (`127.0.0.1:8080`).
- **openwebui-traefik**: Runs OpenWebUI with Traefik labels for HTTPS routing.
- **openwebui-tailscale**: Runs OpenWebUI with Tailscale for secure remote access.
- **tailscale**: Provides secure networking for the `tailscale` profile.

## Quick Start
Follow these steps to deploy OpenWebUI:

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/brainxio/openwebui.git
   cd openwebui
   ```

2. **Set Up Environment**:
   - Copy `.env.example` to `.env`:
     ```bash
     cp .env.example .env
     ```
   - Edit `.env` to configure variables:
     - `OPENWEBUI_PORT=127.0.0.1:8080`: Binds OpenWebUI to localhost on port 8080 (default).
     - `OPENWEBUI_VOLUME=openwebui-data`: Uses a Docker volume for data storage (default). Set to `./openwebui_data` for a local directory.
     - `TSAUTHKEY_PATH=./secrets/tsauthkey`: Path to the Tailscale authentication key file.
     - `TAILSCALE_HOSTNAME=openwebui`: Tailscale hostname (default).
     - `OPENWEBUI_VERSION=main`: OpenWebUI image version (default).
     - `TAILSCALE_VERSION=stable`: Tailscale image version (default).
     - `OPENWEBUI_NETWORK_NAME=openwebui-net`: Docker network name (default).
     - `OPENWEBUI_NETWORK_EXTERNAL=false`: Creates a new network (default). Set to `true` if using an existing network.
     - `OPENWEBUI_ENABLE_TRAEFIK=false`: Disables Traefik by default. Set to `true` for HTTPS routing.
     - `DOMAIN=yourdomain.com`: Required if `OPENWEBUI_ENABLE_TRAEFIK=true` for HTTPS access.
     - `IP_WHITELIST=0.0.0.0/0`: Allows all IPs for Traefik (default). Restrict to specific IPs (e.g., `192.168.1.0/24`) for security.
   - For Tailscale, create the auth key file:
     ```bash
     mkdir -p secrets
     echo "tskey-auth-abc123xyz789" > secrets/tsauthkey
     chmod 600 secrets/tsauthkey
     ```
   - If `OPENWEBUI_NETWORK_EXTERNAL=true`, create the network:
     ```bash
     docker network create openwebui-net
     ```

3. **Launch the Stack**:
   Use Docker Compose profiles to deploy:
   - Local:
     ```bash
     docker compose --profile local up -d
     ```
   - Traefik (set `OPENWEBUI_ENABLE_TRAEFIK=true`, `DOMAIN`):
     ```bash
     echo "OPENWEBUI_ENABLE_TRAEFIK=true" >> .env
     echo "DOMAIN=yourdomain.com" >> .env
     docker compose --profile traefik up -d
     ```
   - Tailscale (set `TSAUTHKEY_PATH`):
     ```bash
     docker compose --profile tailscale up -d
     ```
   - Check running services:
     ```bash
     docker compose ps
     ```

4. **Access OpenWebUI**:
   - Local: `http://localhost:8080`.
   - Traefik: `https://chat.${DOMAIN:-localhost}`.
   - Tailscale: `http://${TAILSCALE_HOSTNAME:-openwebui}.yourtailnet.ts.net:8080` within Tailscale network.

## Security Considerations
- **Restrict Local Access**: The default `OPENWEBUI_PORT=127.0.0.1:8080` binds to localhost, preventing external access. Avoid setting `OPENWEBUI_PORT=8080` unless necessary, as it exposes the service publicly.
- **Use Tailscale**: Tailscale provides encrypted, secure remote access. Ensure `TSAUTHKEY_PATH` points to a secure file with restricted permissions (e.g., `chmod 600 secrets/tsauthkey`).
- **Enable Traefik with IP Whitelisting**: Set `OPENWEBUI_ENABLE_TRAEFIK=true` and configure `IP_WHITELIST` to limit access to trusted IP ranges (e.g., `192.168.1.0/24`). Avoid `0.0.0.0/0` in production.
- **Secure Data Storage**: Use `OPENWEBUI_VOLUME=openwebui-data` for a managed Docker volume. If using `./openwebui_data`, ensure the directory has restricted permissions (`chmod 700 openwebui_data`).
- **Keep Images Updated**: Use `OPENWEBUI_VERSION=main` and `TAILSCALE_VERSION=stable` for security patches, but test updates in a non-production environment first.

## Directory Structure
```
.
├── docker-compose.yml              # Consolidated configuration for OpenWebUI
├── docs/
│   ├── 01-agent-machine-hardware.md
│   ├── 02-base-model-selection.md
│   ├── 03-character-identity.md
│   ├── 04-functions.md
│   ├── 05-tools.md
│   ├── 06-deployment.md
├── .env.example                    # Environment variable template
├── .gitignore                      # Ignores sensitive files
├── .yamllint.yml                   # YAML linting configuration
├── CHANGELOG.md                    # Tracks project updates
├── deploy.sh                       # Deployment script
├── LICENSE                         # MIT License
└── secrets/                        # Directory for Tailscale auth key
```

## Features
- **Modular Profiles**: Select configurations using profiles (`local`, `traefik`, `tailscale`).
- **Flexible Storage**: Store data in a Docker volume (`openwebui-data`) or local directory (`./openwebui_data`) via `OPENWEBUI_VOLUME`.
- **Secure Networking**: Local access via `127.0.0.1`, Tailscale for encrypted remote access, or Traefik for HTTPS routing with IP whitelisting.

## Troubleshooting
- **Network Issues**: Verify `openwebui-network` exists if `OPENWEBUI_NETWORK_EXTERNAL=true` (`docker network ls`). Check Traefik logs if using `traefik` profile.
- **Tailscale Problems**: Ensure `TSAUTHKEY_PATH` points to a valid auth key and check the Tailscale admin console for connection issues.
- **Access Errors**: Confirm `.env` settings (`OPENWEBUI_PORT`, `DOMAIN`, `IP_WHITELIST`, `OPENWEBUI_ENABLE_TRAEFIK`) are correct. Test local access with `curl http://localhost:8080/health`.
- **Volume Issues**: If using `OPENWEBUI_VOLUME=./openwebui_data`, ensure the directory exists (`mkdir openwebui_data`). For `openwebui-data`, verify the volume exists (`docker volume ls`).

## Contributing
Fork the repository, make changes, and submit a pull request. Open issues for bugs or feature requests.

## License
[LICENSE](LICENSE) - MIT License.