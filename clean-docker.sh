#!/bin/bash

set -e

echo "🔥 Cleaning Docker unused resources..."
docker system prune -a -f --volumes

echo "🔥 Cleaning temporary folders..."
sudo rm -rf /tmp/* /var/tmp/*

echo "🔥 Cleaning old logs..."
sudo rm -rf /var/log/journal/*
sudo rm -f /var/log/*.gz
sudo rm -f /var/log/*.1

echo "🔥 Cleaning Snap cache..."
sudo rm -rf /var/cache/snapd/*

echo "🔥 Cleaning APT cache..."
sudo apt-get clean
sudo rm -rf /var/cache/apt/archives/*

echo "✅ System cleanup complete!"
