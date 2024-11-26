


# S3 Buckets with Enhanced Configuration
resource "aws_s3_bucket" "raw_data_bucket" {
  bucket = "${var.project_name}-raw-data"
  
  tags = {
    Name        = "Raw Data Bucket"
    Environment = "Production"
    Project     = "Patient Data Processing"
  }
}

resource "aws_s3_bucket_versioning" "raw_bucket_versioning" {
  bucket = aws_s3_bucket.raw_data_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "processed_data_bucket" {
  bucket = "${var.project_name}-processed-data"
  
  tags = {
    Name        = "Processed Data Bucket"
    Environment = "Production"
    Project     = "Patient Data Processing"
  }
}

resource "aws_s3_bucket_versioning" "processed_bucket_versioning" {
  bucket = aws_s3_bucket.processed_data_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.raw_data_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.patient_data_processor.arn
    events              = ["s3:ObjectCreated:*"]
  }
  depends_on = [aws_lambda_permission.allow_s3_invoke]
}

# Upload sample JSON file to S3 bucket
resource "aws_s3_object" "sample_data" {
  bucket = aws_s3_bucket.raw_data_bucket.id
  key    = "ikerian_sample.json"
  source = "../data/ikerian_sample.json"
  
  # Optional: Ensure file is uploaded only if content changes
  etag = filemd5("../data/ikerian_sample.json")
}
