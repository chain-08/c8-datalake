variable "region" {
  description = "AWS region to deploy into"
  default     = "us-east-1"
}

variable "office_cidr" {
  description = "Your office IP/CIDR for SSH & ClickHouse access"
  type        = string
}

variable "key_name" {
  description = "Name of your existing AWS keypair"
  type        = string
}

variable "public_key_path" {
  description = "Local path to your SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "instance_type" {
  description = "EC2 instance type for ClickHouse"
  type        = string
  default     = "t3.micro"
}
