# 06 - Deployment

## Overview
This guide explains how to deploy OpenWebUI using Docker Compose with modular overrides for Tailscale, Traefik, ports, and volumes.

## Prerequisites
- Docker and Docker Compose installed.
- `.env` file configured (see `.env.example`).
- Traefik network (`traefik-net`) set up if using Traefik.

## Deployment Steps
1. **Prepare Environment**:
   - Copy `.env.example` to `.env` and set: `DOMAIN=yourdomain.com`, `IP_WHITELIST=your_ip/32`, `TSAUTHKEY_PATH=~/.secrets/openwebui-tsauthkey.key` (for Tailscale).
   - Warning: Do not commit `.env` to version control—contains sensitive data!
   - Run Ollama separately: `ollama serve` with `OLLAMA_BASE_URL=http://host.docker.internal:11434` in `.env`.
2. **Launch the Stack**:
   - Base: `docker compose -f docker-compose.yml up -d --build`.
   - Add Ports: `docker compose -f docker-compose.yml -f docker-compose.add.ports.yml up -d --build` for local access.
   - Add Tailscale: `docker compose -f docker-compose.yml -f docker-compose.add.tailscale.yml up -d --build` for secure networking.
   - Add Traefik: `docker compose -f docker-compose.yml -f docker-compose.add.traefik.yml up -d --build` for routing.
   - Add Traefik-Tailscale: `docker compose -f docker-compose.yml -f docker-compose.add.traefik-tailscale.yml up -d --build` for combined setup.
   - Add Volume: `docker compose -f docker-compose.yml -f docker-compose.add.volume.yml up -d --build` for external storage.
   - Combos: e.g., Tailscale + Traefik: `-f docker-compose.add.tailscale.yml -f docker-compose.add.traefik-tailscale.yml`.
3. **Verify Deployment**:
   - Check status: `docker compose ps`—healthy services glow!
   - Access: `http://localhost:8080` (ports), `http://chat.yourdomain.com` (Traefik), or Tailscale IP.
4. **Additional Setup**:
   - Pull models: `ollama pull mistral-small3.2:latest` (24B fits!).
   - Import agents: In OpenWebUI, go to **Settings > Models > Create Model**, upload `planner.json`, `critic.json`, `entertainer.json`.
   - Set filters/tools: Place `/filters/` and `/tools/` dirs, restart with `docker compose restart`.
   - Allocate resources: Use `docker compose --profile` with `--resources` (e.g., `cpus=12, memory=90g`) for Ryzen 9 3900X.

## Configuration
- **Overrides**: Modular add-ons—combine as needed.
- **Tailscale IP**: Access via Tailscale-assigned IP (check `tailscale status`).
- **Traefik Network**: Ensure `traefik-net` is external.

## Troubleshooting
- **Network Issues**: Check Traefik logs, verify `traefik-net`.
- **Tailscale Failure**: Confirm auth key, `/dev/net/tun` access.
- **Ollama Link**: Match `OLLAMA_BASE_URL`.
- **Resource Limits**: Adjust Docker resources if slow.

## Resources
- [OpenWebUI Docs](https://docs.openwebui.com/)