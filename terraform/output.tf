output "raw_bucket_name" {
  value = aws_s3_bucket.raw_data_bucket.id
}

output "processed_bucket_name" {
  value = aws_s3_bucket.processed_data_bucket.id
}

output "lambda_function_name" {
  value = aws_lambda_function.patient_data_processor.function_name
}