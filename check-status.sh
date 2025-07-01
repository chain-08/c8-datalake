#!/bin/bash

set -e

echo "🚀 Running system status check..."

# --------------------------
# Check Disk Mounts
# --------------------------
MOUNT_PATH="/mnt/clickhouse-data"

if mount | grep "$MOUNT_PATH" > /dev/null; then
  echo "✅ Mount check: $MOUNT_PATH is mounted."
else
  echo "❌ Mount check FAILED: $MOUNT_PATH is NOT mounted."
  exit 1
fi

# --------------------------
# Check Disk Usage
# --------------------------
echo "🗄️ Disk usage:"
df -h "$MOUNT_PATH"

# --------------------------
# Check Docker Service
# --------------------------
if systemctl is-active --quiet docker; then
  echo "✅ Docker service is running."
else
  echo "❌ Docker service is NOT running."
  exit 1
fi

# --------------------------
# Check Docker Containers
# --------------------------
echo "🐳 Docker containers status:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Check if clickhouse container is running
if docker ps --format '{{.Names}}' | grep -q "clickhouse-datalake"; then
  echo "✅ ClickHouse container is running."
else
  echo "❌ ClickHouse container is NOT running."
  exit 1
fi

# --------------------------
# Check ClickHouse Server Health
# --------------------------
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8123/ping)

if [ "$HTTP_CODE" -eq 200 ]; then
  echo "✅ ClickHouse HTTP healthcheck passed."
else
  echo "❌ ClickHouse HTTP healthcheck failed."
  exit 1
fi

# --------------------------
# Final Status
# --------------------------
echo "🎯 All checks passed. System is healthy."
exit 0
