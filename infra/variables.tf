variable "region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance size"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name for the SSH key‐pair in AWS"
  type        = string
  default     = "c8-datalake-key"
}

variable "public_key_path" {
  description = "Absolute path on your workstation to the SSH public key"
  type        = string
  # <<< Replace `inglorious` with your actual Linux username if different
  default     = "/home/inglorious/.ssh/c8-datalake-key.pub"
}

variable "office_cidr" {
  description = "Your office IP/CIDR allowed to SSH & ClickHouse"
  type        = string
}
