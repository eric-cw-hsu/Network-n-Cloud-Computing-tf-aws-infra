resource "aws_lambda_function" "csye6225_send_verification_email" {
  filename      = "bootstrap.zip"
  function_name = "send_verification_email"
  role          = aws_iam_role.csye6225_lambda_exec_role.arn
  handler       = "send_verification_email"
  runtime       = "provided.al2"
  timeout       = 120

  environment {
    variables = {
      SENDGRID_API_KEY  = var.sendgrid_api_key
      WEBAPP_HOSTNAME   = "http://${var.domain_name}"
      EMAIL_SENDER_ADDR = var.email_sender_address
      EMAIL_SENDER_NAME = var.email_sender_name
    }
  }
}
