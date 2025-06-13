terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# 1) Latest Ubuntu Jammy AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-*-amd64-server-*"]
  }
}

# 2) Security group for SSH + ClickHouse ports
resource "aws_security_group" "clickhouse" {
  name        = "c8-clickhouse-sg"
  description = "Allow SSH & ClickHouse from your office"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.office_cidr]
  }

  ingress {
    description = "HTTP (8123)"
    from_port   = 8123
    to_port     = 8123
    protocol    = "tcp"
    cidr_blocks = [var.office_cidr]
  }

  ingress {
    description = "Native TCP (9000)"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = [var.office_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3) EC2 instance running your deploy.sh on first boot
resource "aws_instance" "clickhouse" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.clickhouse.id]

  # User-data script to install Docker & run docker-compose
  user_data = file("${path.module}/deploy.sh")

  tags = {
    Name = "c8-datalake-clickhouse"
  }
}

