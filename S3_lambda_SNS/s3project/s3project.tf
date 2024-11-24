#managed policies
resource "aws_iam_policy" "policy_s3_sns_lambda" {
  name = "policy-238399"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:*"]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = ["lambda:*"]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = ["cloudwatch:*",
        "logs:*"]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = ["SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

#creation of IAM role
resource "aws_iam_role" "test_role" {
  name = "test_role"
  managed_policy_arns = [aws_iam_policy.policy_s3_sns_lambda.arn]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = ["ec2.amazonaws.com", "s3.amazonaws.com", "lambda.amazonaws.com", "sns.amazonaws.com"]
        }
      },
    ]
  })
}
#create s3 bucket
resource "aws_s3_bucket" "example" {
  bucket = "alok-test-s3-2383999"
}