from time import time_ns

import bcrypt
import boto3
import jwt


def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('users')

    try:
        username = event['username']
        password = event['password']

        # Retrieve user data from DynamoDB
        response = table.get_item(Key={'username': username})
        if 'Item' not in response:
            return {
                'statusCode': 401,
                'body': 'Invalid username or password'
            }

        user = response['Item']

        # Verify password
        if not bcrypt.checkpw(password.encode('utf-8'), user['hashedPassword'].encode('utf-8')):
            return {
                'statusCode': 401,
                'body': 'Invalid username or password'
            }

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

        return {
            'statusCode': 200,
            'body': {
                'name': user['name'],
                'token': token
            }
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': f'An error occurred: {str(e)}'
        }
