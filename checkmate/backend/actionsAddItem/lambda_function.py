import json
from time import time_ns

import boto3
import jwt


def api_gateway_formatter(status, body):
    return {
        'statusCode': status,
        'headers': {
            'Content-Type': 'application/json'
        },
        'body': json.dumps(body),
        'isBase64Encoded': False
    }


def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('user_tasks')

    # Extract JWT token from authorization header
    token = event['headers']['authorization'].split()[1]

    # Verify JWT token
    try:
        payload = jwt.decode(token, 'your_secret_key', algorithms=['HS256'])
        username = payload['username']
    except jwt.ExpiredSignatureError:
        return api_gateway_formatter(401, 'Token expired')
    except jwt.InvalidTokenError:
        return api_gateway_formatter(403, 'Invalid token')

    # Generate a timestamp for the task ID
    taskId = str(time_ns())

    # Obtain the new task text
    body = json.loads(event['body'])
    text = body['text']

    # Create a new task item
    item = {
        'username': username,
        'id': taskId,
        'text': text,
    }

    # Put the item into DynamoDB
    try:
        table.put_item(Item=item)
    except Exception as e:
        return api_gateway_formatter(500, f'An error occurred: {str(e)}')
    else:
        return api_gateway_formatter(200, 'Task created successfully')
