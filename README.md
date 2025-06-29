# 🚀 C8-Datalake — Automated with GitHub Actions

## ✅ Features
- Automated deployment via GitHub Actions
- Automated log upload to AWS S3
- Automated Docker and system cleanup

---

## 🚀 Folder Structure
```plaintext
.github/workflows/        → GitHub Actions workflow
infra/                    → Terraform infra
clickhouse/               → ClickHouse configs
init/                     → DB init (if any)
secrets/                  → ClickHouse secrets
upload-logs.sh            → Log upload to S3
clean-docker.sh           → Docker cleanup
docker-compose.yml        → Docker services
.env.example              → Template for environment variables
