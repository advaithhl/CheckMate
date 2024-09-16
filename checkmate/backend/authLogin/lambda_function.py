import json
from time import time_ns

import bcrypt
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
    table = dynamodb.Table('users')

    try:
        body = json.loads(event['body'])
        username = body['username']
        password = body['password']

        # Retrieve user data from DynamoDB
        response = table.get_item(Key={'username': username})
        if 'Item' not in response:
            return api_gateway_formatter(401, 'Invalid username or password')

        user = response['Item']

        # Verify password
        if not bcrypt.checkpw(password.encode('utf-8'), user['hashedPassword'].encode('utf-8')):
            return api_gateway_formatter(401, 'Invalid username or password')

        # Create JWT payload
        jwt_payload = {
            'name': user['name'],
            'username': user['username'],
            'password': user['hashedPassword'],
            'time_ns': time_ns(),  # This is to ensure that tokens are unique
        }

        # Generate JWT token
        token = jwt.encode(
            jwt_payload,
            'your_secret_key',
            algorithm='HS256',
        )

        return api_gateway_formatter(200, {
            'name': user['name'],
            'token': token
        })

    except Exception as e:
        return api_gateway_formatter(500, f'An error occurred: {str(e)}')
