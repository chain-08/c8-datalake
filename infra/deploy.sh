#!/usr/bin/env bash
set -euo pipefail

### 1) Install prerequisites (incl. Git) ###
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    software-properties-common \
    git

### 2) Install Docker & the “docker compose” plugin ###
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  > /etc/apt/sources.list.d/docker.list

apt-get update
apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-compose-plugin

### 3) Make sure docker daemon is running ###
systemctl enable docker
systemctl start docker

### 4) Fetch your Compose repo and fire it up ###
TARGET=/opt/c8-datalake
mkdir -p "$TARGET"

# if this is a fresh VM, download the tarball; otherwise do a pull
if [ ! -f "$TARGET/docker-compose.yml" ]; then
  curl -fsSL https://codeload.github.com/chain-08/c8-datalake/tar.gz/master \
    | tar -xz --strip-components=1 -C "$TARGET"
else
  (cd "$TARGET" && git pull)
fi

cd "$TARGET"
docker compose pull
docker compose up -d
