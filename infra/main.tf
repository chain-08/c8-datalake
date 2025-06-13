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

# Find the latest Ubuntu Jammy AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-*-amd64-server-*"]
  }
}

# Security group for ClickHouse
resource "aws_security_group" "clickhouse" {
  name        = "c8-clickhouse-sg"
  description = "Allow ClickHouse ports from your office IP"

  ingress {
    description = "HTTP interface"
    from_port   = 8123
    to_port     = 8123
    protocol    = "tcp"
    cidr_blocks = [var.office_cidr]
  }

  ingress {
    description = "Native TCP interface"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = [var.office_cidr]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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


# EC2 instance running Docker & your Compose stack
resource "aws_instance" "clickhouse" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.clickhouse.id]

  # This is the script that installs Docker & runs docker-compose
  user_data = file("${path.module}/deploy.sh")

  tags = {
    Name = "c8-datalake-clickhouse"
  }
}
