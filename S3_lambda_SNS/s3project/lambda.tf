data "archive_file" "python_lambda_package" {  
  type = "zip"  
  source_file = "${path.module}/s3_lambda_function.py" 
  output_path = "${path.module}/s3_lambda_function.zip"
}

#create lambda function
resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "${path.module}/s3_lambda_function.zip"
  function_name = "s3-lambda-function"
  role          = aws_iam_role.test_role.arn
  handler       = "s3_lambda_function.lambda_handler"
  timeout       = 30
  runtime = "python3.12"
}

#adding permission to lambda function
resource "aws_lambda_permission" "all" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.test_lambda.arn}"
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${aws_s3_bucket.example.id}"
}

# Create an S3 event trigger for the Lambda function
resource "aws_s3_bucket_notification" "my-trigger" {
  bucket = "alok-test-s3-2383999"
  lambda_function {
    lambda_function_arn = aws_lambda_function.test_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.all]
}