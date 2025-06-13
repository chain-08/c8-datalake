#!/usr/bin/env bash
set -euo pipefail

# 1) Install prerequisites (incl. git)
apt-get update
apt-get install -y ca-certificates curl gnupg lsb-release git

# 2) Add Docker’s official GPG key and repo
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  > /etc/apt/sources.list.d/docker.list

# 3) Install Docker & Compose plugin
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 4) Ensure Docker service is enabled & running
systemctl enable docker
systemctl start docker

# 5) Clone (or update) your repo and bring up the stack
mkdir -p /opt/c8-datalake
cd /opt/c8-datalake

if [ ! -d .git ]; then
  git clone https://github.com/chain-08/c8-datalake.git .
else
  git pull
fi

docker compose up -d
