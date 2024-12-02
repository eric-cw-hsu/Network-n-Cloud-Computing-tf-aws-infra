resource "random_password" "database_password" {
  length  = 16
  special = false
  upper   = true
  lower   = true
  numeric = true
}

resource "aws_secretsmanager_secret" "db_password" {
  name        = "database-password-${formatdate("YYYY-MM-DD-hh-mm", timestamp())}"
  description = "Database password for RDS instance"
  kms_key_id  = aws_kms_key.secrets_key.arn
}

resource "aws_secretsmanager_secret_version" "db_password_version" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = jsonencode({ password = random_password.database_password.result })
}

resource "aws_secretsmanager_secret" "email_service_credentials" {
  name        = "lambda-email-service-credentials-${formatdate("YYYY-MM-DD-hh-mm", timestamp())}"
  description = "Credentials for email service"
  kms_key_id  = aws_kms_key.secrets_key.arn
}

resource "aws_secretsmanager_secret_version" "email_service_credentials_version" {
  secret_id = aws_secretsmanager_secret.email_service_credentials.id
  secret_string = jsonencode({
    SENDGRID_API_KEY  = var.sendgrid_api_key,
    WEBAPP_HOSTNAME   = "https://${var.domain_name}",
    EMAIL_SENDER_ADDR = var.email_sender_address,
    EMAIL_SENDER_NAME = var.email_sender_name
  })
}
