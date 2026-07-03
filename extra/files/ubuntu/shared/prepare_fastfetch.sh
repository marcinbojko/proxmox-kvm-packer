#!/usr/bin/env bash
# Install and configure fastfetch (replaces neofetch).
set -e

config="/etc/fastfetch.jsonc"
src_config="/tmp/fastfetch.jsonc"

# Remove the legacy neofetch package and config if present
export DEBIAN_FRONTEND=noninteractive
apt-get -y remove neofetch 2>/dev/null || true
rm -rf /etc/neofetch

# Install fastfetch from the distribution repo (24.04+ ships it)
if ! command -v fastfetch >/dev/null 2>&1; then
  apt-get -y update || true
  apt-get -y install fastfetch || true
fi

# Fall back to the pinned upstream .deb when the repo has no package (e.g. 22.04)
if ! command -v fastfetch >/dev/null 2>&1; then
  arch="$(dpkg --print-architecture)"
  ff_ver="2.64.2"
  deb="/tmp/fastfetch_${ff_ver}.deb"
  url="https://github.com/fastfetch-cli/fastfetch/releases/download/${ff_ver}/fastfetch-linux-${arch}.deb"
  echo "fastfetch not in repo - installing upstream .deb ${ff_ver} for ${arch}"
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL -o "$deb" "$url"
  else
    wget -O "$deb" "$url"
  fi
  apt-get -y install "$deb" || dpkg -i "$deb"
fi

# Place the shared config
if [ -e "$src_config" ]; then
  echo "Copying fastfetch config to $config"
  cp -pv "$src_config" "$config"
fi

if command -v fastfetch >/dev/null 2>&1; then
  fastfetch --config "$config" || true
  echo "Finished fastfetch configuration"
else
  echo "fastfetch could not be installed" >&2
  exit 1
fi
