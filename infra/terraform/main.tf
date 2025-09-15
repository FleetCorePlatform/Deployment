# TLS key for EC2 ssh keypair
resource "tls_private_key" "fleetcore" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "fleetcore" {
  key_name   = "fleetcore-key-${random_id.suffix.hex}"
  public_key = tls_private_key.fleetcore.public_key_openssh
}

# VPC + subnet + IGW + RT
resource "aws_vpc" "fleetcore_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "fleetcore-vpc" }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "fleetcore_subnet" {
  vpc_id                  = aws_vpc.fleetcore_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags                    = { Name = "fleetcore-subnet" }
}

resource "aws_internet_gateway" "fleetcore_igw" {
  vpc_id = aws_vpc.fleetcore_vpc.id
  tags   = { Name = "fleetcore-igw" }
}

resource "aws_route_table" "fleetcore_rt" {
  vpc_id = aws_vpc.fleetcore_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.fleetcore_igw.id
  }
  tags = { Name = "fleetcore-rt" }
}

resource "aws_route_table_association" "fleetcore_rta" {
  subnet_id      = aws_subnet.fleetcore_subnet.id
  route_table_id = aws_route_table.fleetcore_rt.id
}

# Security group (SSH, HTTP, app ports)
resource "aws_security_group" "fleetcore_sg" {
  name        = "fleetcore-sg-${random_id.suffix.hex}"
  description = "Allow SSH, HTTP, optionally app ports"
  vpc_id      = aws_vpc.fleetcore_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Example Quarkus default HTTP port: 8080
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "fleetcore-sg" }
}

# EC2 instance profile & IAM role (allow S3 get & SQS read & RDS connect via secrets if later)
data "aws_iam_policy_document" "ec2_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "fleetcore-ec2-role-${random_id.suffix.hex}"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
}

resource "aws_iam_role_policy_attachment" "s3_read" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "sqs_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "fleetcore-instance-profile-${random_id.suffix.hex}"
  role = aws_iam_role.ec2_role.name
}

# EC2 (Ubuntu AMI)
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_instance" "fleetcore_app" {
  count         = var.instance_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.fleetcore.key_name
  subnet_id     = aws_subnet.fleetcore_subnet.id
  vpc_security_group_ids = [aws_security_group.fleetcore_sg.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  tags = { Name = "fleetcore-app-${count.index}" }
}

# S3 bucket for artifacts & logs; lifecycle transitions to Glacier after 90 days
resource "aws_s3_bucket" "artifacts" {
  bucket = var.s3_bucket_name
  acl    = "private"

  versioning { enabled = true }

  lifecycle_rule {
    id      = "glacier-transition"
    enabled = true

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    expiration {
      days = 3650
    }
  }

  tags = { Name = "fleetcore-artifacts" }
}

# SQS for telemetry
resource "aws_sqs_queue" "telemetry" {
  name = "fleetcore-telemetry-${random_id.suffix.hex}"
}

# Cognito User Pool
resource "aws_cognito_user_pool" "fleetcore" {
  name = "fleetcore-user-pool-${random_id.suffix.hex}"

  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  schema {
    name = "email"
    attribute_data_type = "String"
    required = true
  }
}

resource "aws_cognito_user_pool_client" "fleetcore_client" {
  name         = "fleetcore-client"
  user_pool_id = aws_cognito_user_pool.fleetcore.id
  explicit_auth_flows = ["ALLOW_REFRESH_TOKEN_AUTH","ALLOW_USER_SRP_AUTH","ALLOW_CUSTOM_AUTH","ALLOW_USER_PASSWORD_AUTH"]
  allowed_oauth_flows_user_pool_client = false
}

# RDS (Postgres) - single AZ for initial PoC
resource "aws_db_subnet_group" "fleetcore" {
  name       = "fleetcore-db-sng-${random_id.suffix.hex}"
  subnet_ids = [aws_subnet.fleetcore_subnet.id]
}

resource "aws_db_instance" "fleetcore_db" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "13"
  instance_class       = "db.t3.micro"
  name                 = var.rds_db_name
  username             = var.rds_username
  password             = var.rds_password
  skip_final_snapshot  = true
  publicly_accessible  = true
  vpc_security_group_ids = [aws_security_group.fleetcore_sg.id]
  db_subnet_group_name = aws_db_subnet_group.fleetcore.name
  tags = { Name = "fleetcore-rds" }
}

# IoT: create policy (resources may require manual cert creation by devices)
resource "aws_iot_policy" "fleetcore" {
  name   = "fleetcore-iot-policy-${random_id.suffix.hex}"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action":["iot:Connect","iot:Publish","iot:Subscribe","iot:Receive"],
      "Resource":["*"]
    }
  ]
}
POLICY
}

# Lambda: create IAM role + function (we expect CI to upload zip to S3 bucket at var.lambda_s3_key)
data "aws_iam_policy_document" "lambda_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals { identifiers = ["lambda.amazonaws.com"]; type = "Service" }
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "fleetcore-lambda-role-${random_id.suffix.hex}"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Allow Lambda to access RDS/S3 as needed — attach S3 readonly for now
resource "aws_iam_role_policy_attachment" "lambda_s3" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_lambda_function" "mission_end" {
  function_name = "fleetcore-mission-end-${random_id.suffix.hex}"
  s3_bucket     = aws_s3_bucket.artifacts.id
  s3_key        = var.lambda_s3_key
  handler       = "handler.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_role.arn
  depends_on = [aws_iam_role_policy_attachment.lambda_logs]
}

# Note: IoT actions & SQS subscriptions may be wired up later with aws_iot_topic_rule resources as needed.

# small data resource to get IoT endpoint
data "aws_iot_endpoint" "iot" {
  endpoint_type = "iot:Data-ATS"
}
