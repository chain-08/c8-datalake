variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 size"
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of your existing EC2 keypair"
  type        = string
}

variable "office_cidr" {
  description = "Your IP/CIDR for SSH and ClickHouse access"
  type        = string
}
