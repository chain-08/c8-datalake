variable "region" {
  type    = string
  default = "us-east-1"
}

variable "office_cidr" {
  type        = string
  description = "Your IP/CIDR for SSH & ClickHouse access"
}

variable "key_name" {
  type        = string
  description = "Name of your existing AWS keypair"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}
