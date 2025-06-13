output "clickhouse_ip" {
  description = "Public IP of the ClickHouse EC2 instance"
  value       = aws_instance.clickhouse.public_ip
}
