import json

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

    # Get items for the specific user
    response = table.query(
        KeyConditionExpression=boto3.dynamodb.conditions.Key(
            'username').eq(username),
        # Avoid including username in each item
        ProjectionExpression="#id, #text",
        ExpressionAttributeNames={
            '#id': 'taskId',
            '#text': 'text'
        }
    )
    items = response['Items']

    return {
        'statusCode': 200,
        'body': json.dumps({'items': items})
    }
