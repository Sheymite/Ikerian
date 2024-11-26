# Lambda Function Configuration
# Data source to create the Lambda zip file
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file  = "../src/code/lambda_function.py"
  output_path = "../src/code/lambda_function.zip"

}

# Data source to read the unzipped Lambda code
data "local_file" "lambda_code" {
  filename = "../src/code/lambda_function.py"
}

# Lambda Function Configuration
resource "aws_lambda_function" "patient_data_processor" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "${var.project_name}-processor"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"
  timeout          = 30
  memory_size      = 256

  environment {
    variables = {
      DESTINATION_BUCKET = aws_s3_bucket.processed_data_bucket.id
      LOG_LEVEL          = "INFO"
    }
  }

  tags = {
    Name        = "Patient Data Processor"
    Environment = "Production"
  }
}

# S3 Event Notification

# S3 Event Notification
resource "aws_lambda_permission" "allow_s3_invoke" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.patient_data_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.raw_data_bucket.arn
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.patient_data_processor.function_name}"
  retention_in_days = 14
}
resource "aws_cloudwatch_event_rule" "run-lambda" {
  name                  = "run-lambda-function"
  description           = "Schedule lambda function"
  schedule_expression   = "rate(30 minutes)"
}

resource "aws_cloudwatch_event_target" "lambda-function-target" {
  target_id = "lambda-function-target"
  rule      = aws_cloudwatch_event_rule.run-lambda.name
  arn       = aws_lambda_function.patient_data_processor.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.patient_data_processor.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.run-lambda.arn
}