import json
from os import getenv as os_getenv

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

    # Extract item ID and JWT token
    item_id = event['pathParameters']['itemId']
    token = event['headers']['authorization'].split()[1]

    # Verify JWT token
    try:
        secret_key = os_getenv('JWT_SECRET_KEY')
        payload = jwt.decode(token, secret_key, algorithms=['HS256'])
        username = payload['username']
    except KeyError:
        return api_gateway_formatter(500, 'An internal server error occured')
    except jwt.ExpiredSignatureError:
        return api_gateway_formatter(401, 'Token expired')
    except jwt.InvalidTokenError:
        return api_gateway_formatter(403, 'Invalid token')

    # Delete the item
    try:
        table.delete_item(
            Key={
                'username': username,
                'id': item_id
            }
        )
        return api_gateway_formatter(200, 'Item deleted successfully')
    except Exception as e:
        return api_gateway_formatter(500, f'An error occurred: {str(e)}')
