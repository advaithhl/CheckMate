import json

import bcrypt
import boto3


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
        name = body['name']
        username = body['username']
        password = body['password']

        # Hash the password for security
        hashed_password = bcrypt.hashpw(
            password.encode('utf-8'), bcrypt.gensalt())

        # Check if username already exists
        response = table.get_item(Key={'username': username})
        if 'Item' in response:
            return api_gateway_formatter(409, 'Username already exists')

        # Put the user data into DynamoDB
        response = table.put_item(
            Item={
                'name': name,
                'username': username,
                'hashedPassword': hashed_password.decode('utf-8')
            }
        )

        return api_gateway_formatter(201, 'User registered successfully')

    except Exception as e:
        return api_gateway_formatter(500, f'An error occurred: {str(e)}')
