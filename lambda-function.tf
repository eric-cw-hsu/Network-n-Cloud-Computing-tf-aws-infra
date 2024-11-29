resource "aws_lambda_function" "csye6225_send_verification_email" {
  filename      = "bootstrap.zip"
  function_name = "send_verification_email"
  role          = aws_iam_role.csye6225_lambda_exec_role.arn
  handler       = "send_verification_email"
  runtime       = "provided.al2"
  timeout       = 120

  environment {
    variables = {
      SECRET_ARN = aws_secretsmanager_secret.email_service_credentials.arn
    }
  }

  depends_on = [
    aws_secretsmanager_secret.email_service_credentials
  ]
}
