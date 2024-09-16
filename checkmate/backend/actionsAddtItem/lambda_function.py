import json
from time import time_ns

import boto3
import jwt


def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('user_tasks')

    # Extract JWT token from authorization header
    token = event['headers']['Authorization'].split()[1]

    # Verify JWT token
    try:
        payload = jwt.decode(token, 'your_secret_key', algorithms=['HS256'])
        username = payload['username']
    except jwt.ExpiredSignatureError:
        return {
            'statusCode': 401,
            'body': json.dumps({'message': 'Token expired'})
        }
    except jwt.InvalidTokenError:
        return {
            'statusCode': 401,
            'body': json.dumps({'message': 'Invalid token'})
        }

    # Generate a timestamp for the task ID
    taskId = str(time_ns())

    # Create a new task item
    item = {
        'username': username,
        'taskId': taskId,
        'text': event['text']
    }

    # Put the item into DynamoDB
    try:
        table.put_item(Item=item)
    except Exception as e:
        return {
            'statusCode': 500,
            'body': f'An error occurred: {str(e)}'
        }
    else:
        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Task created successfully'})
        }
