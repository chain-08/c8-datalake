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
  description = "Name of your existing AWS EC2 key-pair (must already exist in AWS)"
  type        = string
  default     = "c8-datalake-key"
}

variable "office_cidr" {
  description = "Your office IP/CIDR allowed to SSH & ClickHouse"
  type        = string
}
