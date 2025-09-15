output "public_ips" {
  value = aws_instance.fleetcore_app[*].public_ip
}

output "s3_bucket" {
  value = aws_s3_bucket.artifacts.bucket
}

output "jar_s3_key" {
  value = var.jar_s3_key
}

output "lambda_s3_key" {
  value = var.lambda_s3_key
}

output "sqs_url" {
  value = aws_sqs_queue.telemetry.id
}

output "rds_endpoint" {
  value = aws_db_instance.fleetcore_db.address
}

output "rds_port" {
  value = aws_db_instance.fleetcore_db.port
}

output "cognito_user_pool_id" {
  value = aws_cognito_user_pool.fleetcore.id
}

output "iot_endpoint" {
  value = data.aws_iot_endpoint.iot.endpoint_address
}

output "private_key_pem" {
  sensitive = true
  value     = tls_private_key.fleetcore.private_key_pem
}

output "app_branch" {
  value = var.app_branch
}
