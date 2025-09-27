#!/bin/bash

# Hardcoded base profiles
declare -a BASE_PROFILES=("local" "traefik" "tailscale")

# Filter applicable profiles (all profiles are always applicable for OpenWebUI)
declare -a APPLICABLE_PROFILES=("${BASE_PROFILES[@]}")

# Check if applicable profiles are available
if [ ${#APPLICABLE_PROFILES[@]} -eq 0 ]; then
  echo "Error: No applicable profiles available"
  exit 1
fi

# Parse command line arguments for --version
VERSION_ARG=""
while [[ $# -gt 0 ]]; do
  case $1 in
    --version=*)
      VERSION_ARG="${1#--version=}"
      shift
      ;;
    *)
      shift
      ;;
  esac
done

# Set OPENWEBUI_VERSION
if [ -n "$VERSION_ARG" ]; then
  OPENWEBUI_VERSION="${VERSION_ARG#v}"  # Strip leading 'v' if present
  echo "Using specified version: $OPENWEBUI_VERSION"
else
  # Fetch the latest tagged release from GitHub
  LATEST_RELEASE=$(curl -s https://api.github.com/repos/open-webui/open-webui/releases/latest)
  if [ -n "$LATEST_RELEASE" ]; then
    OPENWEBUI_VERSION=$(echo "$LATEST_RELEASE" | grep -o '"tag_name": *"[^"]*' | grep -o '[^"]*$' | sed 's/^v//')
    if [ -n "$OPENWEBUI_VERSION" ]; then
      echo "Using latest tagged release: $OPENWEBUI_VERSION"
      # Extract and save release notes to openwebui-deploy.md
      RELEASE_NOTES=$(echo "$LATEST_RELEASE" | grep -o '"body": *"[^"]*' | grep -o '[^"]*$' | sed 's/\\n/\n/g')
      if [ -n "$RELEASE_NOTES" ]; then
        echo -e "# OpenWebUI Release Notes\n\n$RELEASE_NOTES" > docs/openwebui-${OPENWEBUI_VERSION}.md
        echo "Release notes saved to docs/openwebui-${OPENWEBUI_VERSION}.md"
      else
        echo "Warning: No release notes available for $OPENWEBUI_VERSION"
      fi
    else
      echo "Error: Could not determine latest tagged release, using default: main"
      OPENWEBUI_VERSION="main"
    fi
  else
    echo "Error: Failed to fetch latest release, using default: main"
    OPENWEBUI_VERSION="main"
  fi
fi

# Display menu and get user selection
echo "Available profiles:"
for i in "${!APPLICABLE_PROFILES[@]}"; do
  echo "$((i+1)). ${APPLICABLE_PROFILES[$i]}"
done
echo "0. Exit"
read -p "Select a profile (1-${#APPLICABLE_PROFILES[@]}, 0 to exit): " CHOICE

# Validate choice
if [ "$CHOICE" -eq 0 ]; then
  echo "Exiting..."
  exit 0
elif ! [[ "$CHOICE" =~ ^[0-9]+$ ]] || [ "$CHOICE" -lt 1 ] || [ "$CHOICE" -gt ${#APPLICABLE_PROFILES[@]} ]; then
  echo "Error: Invalid selection"
  exit 1
fi

PROFILE=${APPLICABLE_PROFILES[$((CHOICE-1))]}
TAILSCALE_HOSTNAME="$(hostname)-openwebui"

# Check for Tailscale profile and handle tsauthkey
if [[ "$PROFILE" == *"tailscale"* ]]; then
  TSAUTHKEY_PATH="${TSAUTHKEY_PATH:-./secrets/tsauthkey}"  # Default to ./secrets/tsauthkey
  if [ ! -f "$TSAUTHKEY_PATH" ]; then
    echo "Error: tsauthkey file not found at $TSAUTHKEY_PATH"
    echo "A Tailscale authentication key is required. Generate one at:"
    echo "https://login.tailscale.com/admin/authkeys"
    read -p "Would you like to create a new key now? (y/n): " CREATE_KEY
    if [ "$CREATE_KEY" = "y" ] || [ "$CREATE_KEY" = "Y" ]; then
      read -s -p "Enter the new Tailscale auth key: " NEW_KEY
      echo
      if [ -n "$NEW_KEY" ]; then
        echo "$NEW_KEY" > "$TSAUTHKEY_PATH"
        echo "tsauthkey created at $TSAUTHKEY_PATH"
        chmod 600 "$TSAUTHKEY_PATH"  # Secure permissions
      else
        echo "Error: No key provided, tsauthkey not created"
        exit 1
      fi
    else
      echo "Please create a tsauthkey file at $TSAUTHKEY_PATH and rerun the script"
      exit 1
    fi
  fi
fi

# Echo the configuration for confirmation
echo "Selected Profile: $PROFILE"
echo "OPENWEBUI_VERSION: $OPENWEBUI_VERSION"
if [[ "$PROFILE" == *"tailscale"* ]]; then
  echo "TAILSCALE_HOSTNAME: $TAILSCALE_HOSTNAME"
  echo "TSAUTHKEY_PATH: $TSAUTHKEY_PATH"
fi

# Export variables for Docker Compose
export TAILSCALE_HOSTNAME
export OPENWEBUI_VERSION

# Deploy with Docker Compose
docker compose --profile "$PROFILE" up -d --force-recreate
