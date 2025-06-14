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

# pick latest Ubuntu Jammy AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-*-amd64-server-*"]
  }
}

# security group
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
    description = "ClickHouse HTTP"
    from_port   = 8123
    to_port     = 8123
    protocol    = "tcp"
    cidr_blocks = [var.office_cidr]
  }
  ingress {
    description = "ClickHouse Native TCP"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = [var.office_cidr]
  }
  egress {
    description = "all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
    ignore_changes = [ description ]
  }
}

# EC2 instance
resource "aws_instance" "clickhouse" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"  # ✅ updated from variable to hard-coded t2.micro for free tier
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.clickhouse.id]

  user_data = templatefile("${path.module}/deploy.sh.tftpl", {
    # no variables needed anymore
  })

  tags = {
    Name = "c8-datalake-clickhouse"
  }
}
