import json
import os
import logging
import boto3

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    # Initialize S3 client
    s3 = boto3.client('s3')
    
    try:
        # Extract bucket and key from event
        source_bucket = event['Records'][0]['s3']['bucket']['name']
        source_key = event['Records'][0]['s3']['object']['key']
        
        # Get destination bucket from environment variable
        destination_bucket = os.environ['DESTINATION_BUCKET']
        
        # Read the JSON file from source bucket
        response = s3.get_object(Bucket=source_bucket, Key=source_key)
        file_content = response['Body'].read().decode('utf-8')
        
        # Parse JSON data
        patients = json.loads(file_content)
        
        # Process patients
        processed_patients = []
        for patient in patients:
            # Extract required fields
            processed_patient = {
                'patient_id': patient['patient_id'],
                'patient_name': patient['patient_name']
            }
            
            # Determine risk state
            if (patient.get('optic_disc_cup_ratio', 0) > 0.5 or 
                patient.get('retina_thickness_microns', 0) > 300):
                processed_patient['risk_state'] = 'high'
            else:
                processed_patient['risk_state'] = 'normal'
            
            processed_patients.append(processed_patient)
        
        # Write processed data to destination bucket
        destination_key = f'processed_{os.path.basename(source_key)}'
        s3.put_object(
            Bucket=destination_bucket, 
            Key=destination_key, 
            Body=json.dumps(processed_patients, indent=2),
            ContentType='application/json'
        )
        
        # Log successful processing
        logger.info(f'Successfully processed {len(processed_patients)} patients')
        
        return {
            'statusCode': 200,
            'body': json.dumps(f'Processed {len(processed_patients)} patients')
        }
    
    except Exception as e:
        # Log any errors
        logger.error(f'Error processing file: {str(e)}')
        return {
            'statusCode': 500,
            'body': json.dumps(f'Error: {str(e)}')
        }