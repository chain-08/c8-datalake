#!/usr/bin/env bash
set -euo pipefail

# Install Docker & Compose plugin
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release

mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  > /etc/apt/sources.list.d/docker.list

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Clone & start the Compose stack
mkdir -p /opt/c8-datalake
cd /opt/c8-datalake

if [ ! -d .git ]; then
  git clone https://github.com/chain-08/c8-datalake.git .
else
  git -C . pull
fi

sudo docker compose up -d
