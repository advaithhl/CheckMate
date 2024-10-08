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

    # Extract JWT token from authorization header
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

    # Get items for the specific user
    response = table.query(
        KeyConditionExpression=boto3.dynamodb.conditions.Key(
            'username').eq(username),
        # Avoid including username in each item
        ProjectionExpression="#id, #text",
        ExpressionAttributeNames={
            '#id': 'id',
            '#text': 'text'
        }
    )
    items = response['Items']

    return api_gateway_formatter(200, {'items': items})
