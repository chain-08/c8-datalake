#!/bin/bash

set -e

TIMESTAMP=$(date +'%Y-%m-%d_%H-%M-%S')
LOG_DIR="/var/log"
S3_BUCKET="${S3_BUCKET:-c8-datalake-logs}"
AWS_REGION="${AWS_REGION:-us-east-1}"

echo "🚀 Uploading logs to S3 bucket: $S3_BUCKET in region $AWS_REGION"

aws s3 cp "$LOG_DIR" "s3://$S3_BUCKET/logs/$TIMESTAMP/" \
    --recursive \
    --exclude "*" \
    --include "*.log" \
    --region "$AWS_REGION" || echo "⚠️ No logs to upload or AWS error."

echo "✅ Logs uploaded to s3://$S3_BUCKET/logs/$TIMESTAMP/"
