resource "aws_sns_topic" "s3_send_email" {
  name = "send_email"
}


resource "aws_sns_topic_subscription" "S3_lambda_send_email" {
  topic_arn = aws_sns_topic.s3_send_email.arn
  protocol  = "email"
  endpoint  = "alok63579@gmail.com"
}