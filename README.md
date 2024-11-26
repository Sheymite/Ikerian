# Ikerian Data Pipeline: Patient Risk Assessment System

## Project Overview
This project implements an end-to-end AWS data pipeline for processing patient medical data using serverless technologies.

### Key Components
- **S3 Storage**: Raw and processed data management
- **Lambda Function**: Serverless data processing
- **Terraform**: Infrastructure as Code (IaC)
- **CloudWatch**: Logging and monitoring

## Architecture

### Data Flow
1. Raw patient JSON uploaded to S3 Raw Bucket
2. S3 event triggers Lambda function
3. Lambda processes data:
   - Validates patient records
   - Determines risk state
   - Writes processed data to Processed Bucket
4. CloudWatch logs capture execution details

### Risk Assessment Logic
- **High Risk Criteria**:
  - Optic Disc Cup Ratio > 0.5
  - Retina Thickness > 300 microns
- **Normal Risk**: All other cases

## Prerequisites

### System Requirements
- AWS Account
- AWS CLI (configured with credentials)
- Terraform (≥ 1.0)
- Python 3.8+
- Git (optional)

### AWS Permissions
Ensure your AWS user/role has:
- S3 bucket creation
- Lambda function creation
- IAM role management
- CloudWatch Log group creation

## Deployment Steps

### 1. Clone Repository
```bash
git clone <repository-url>
cd ikerian_data_pipeline
```

### 2. Configure AWS Credentials
```bash
aws configure
```

### 3. Prepare Lambda Package
```bash
cd scripts
chmod +x setup.sh
./setup.sh
```

### 4. Verify Deployment
- Check S3 buckets
- Test Lambda function
- Review CloudWatch logs

## Configuration Options

### Terraform Variables
- `region`: AWS deployment region
- `project_name`: Prefix for resources

### Lambda Environment Variables
- `DESTINATION_BUCKET`: Processed data bucket
- `LOG_LEVEL`: Logging verbosity

## Monitoring and Logs
- CloudWatch Logs: Lambda execution logs
- S3 Event Notifications
- Detailed error handling in Lambda function

## Troubleshooting
- Check CloudWatch logs for detailed error messages
- Verify AWS IAM permissions
- Ensure valid JSON input

## Security Considerations
- Least privilege IAM roles
- S3 bucket versioning
- Input data validation

## Future Improvements
- Add data encryption
- Implement more complex risk models
- Add metrics and alerting

## Key Implementation Details

### Lambda Function Specifics:

- Extracts only patient_id and patient_name
- Adds risk_state based on specified conditions
- Handles potential errors
Logs processing details


### Terraform Configuration:

- Creates S3 buckets with force_destroy
- Sets up IAM role with least privilege
- Configures CloudWatch logging
- Sets up S3 event notification


### Security Considerations:

- Minimal IAM permissions
- Error handling in Lambda
- CloudWatch logging for monitoring



## Deployment Workflow

- Package Lambda function
- Initialize Terraform
- Apply infrastructure
- Upload sample JSON
- Verify processing