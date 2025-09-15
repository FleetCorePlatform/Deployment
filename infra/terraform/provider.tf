terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_testing ? "us-east-1" : var.aws_region
  
  # Only skip checks if testing
  skip_credentials_validation = var.aws_testing
  skip_requesting_account_id  = var.aws_testing

  # only provide dummy keys if testing
  access_key = var.aws_testing ? "FAKEKEY" : null
  secret_key = var.aws_testing ? "FAKESECRET" : null
}
