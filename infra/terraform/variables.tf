// Cloud provider
variable "cloud_provider" {
  type    = string
  default = "aws"
}

// AWS region
variable "aws_region" {
  type    = string
  default = "us-east-1"
}

// Networking
variable "vpc_cidr_block" {
  type = string
}

variable "public_subnet_cidr" {
  type = string
}

variable "private_subnet_cidr" {
  type = string
}

// SSH key
variable "ssh_key_name" {
  type = string
}

// Application source branch
variable "app_branch" {
  type    = string
  default = "main"
}

// Instance settings
variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "instance_count" {
  type    = number
  default = 1
}

// S3 artifacts
variable "s3_bucket_name" {
  type = string
}

variable "jar_s3_key" {
  type    = string
  default = "artifacts/FleetCoreServer.jar"
}

variable "lambda_s3_key" {
  type    = string
  default = "lambda/mission_end.zip"
}

// RDS settings
variable "rds_db_name" {
  type    = string
  default = "fleetcore"
}

variable "rds_username" {
  type    = string
  default = "fleetcore"
}

variable "rds_password" {
  type      = string
  sensitive = true
}
