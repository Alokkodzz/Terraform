import json
import boto3
import os

Client = boto3.client('sns')

def lambda_handler(event, context):

    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    
   
    message = f"A new file {key} has been uploaded to S3 bucket {bucket}"
    
    
    response = Client.publish(
        TopicArn='arn:aws:sns:us-east-1:528757788286:send_email',
        Message=message
    )
    
    return {
        'statusCode': 200,
        'body': json.dumps('Message published to SNS!')
    }