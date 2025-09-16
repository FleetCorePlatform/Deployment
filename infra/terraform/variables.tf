variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_testing" {
  type    = bool
  default = false
}

variable "cloud_provider" {
  type    = string
  default = "aws"
}

variable "vpc_cidr_block" {
  type = string
}

variable "public_subnet_cidr" {
  type = string
}

variable "private_subnet_cidr" {
  type = string
}

variable "ssh_key_name" {
  type = string
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

variable "s3_bucket_name" {
  type    = string
  default = "fleetcore-artifacts"
}

variable "jar_s3_key" {
  type    = string
  default = "artifacts/FleetCoreServer.jar"
}

variable "lambda_s3_key" {
  type    = string
  default = "lambda/mission_end.zip"
}

variable "rds_db_name" {
  type    = string
  default = "fleetcore"
}

variable "rds_username" {
  type    = string
  default = "fleetcore"
}

variable "rds_password" {
  type = string
}
