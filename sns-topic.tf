resource "aws_sns_topic" "csye6225_user_signup_topic" {
  name = "csye6225_user_signup_topic"
}

resource "aws_sns_topic_subscription" "lambda_subscription" {
  topic_arn = aws_sns_topic.csye6225_user_signup_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.csye6225_send_verification_email.arn
}

resource "aws_lambda_permission" "allow_sns" {
  statement_id  = "AllowSNSInvokeLambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.csye6225_send_verification_email.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.csye6225_user_signup_topic.arn
}
