output "clickhouse_ip" {
  description = "Public IP of the ClickHouse EC2"
  value       = aws_instance.clickhouse.public_ip
}
