variable "cloud_provider" {
  type    = string
  default = "aws"
}

variable "vpc_cidr_block" {
  type    = string
}

variable "public_subnet_cidr" {
  type    = string
}

variable "private_subnet_cidr" {
  type    = string
}

variable "ssh_key_name" {
  type    = string
}

variable "app_branch" {
  type    = string
  default = "main"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "instance_count" {
  type    = number
  default = 1
}
