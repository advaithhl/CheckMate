import json

import boto3
import jwt


def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('user_tasks')

    # Extract item ID and JWT token
    item_id = event['pathParameters']['itemId']
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

    # Delete the item
    try:
        table.delete_item(
            Key={
                'username': username,
                'taskId': item_id
            }
        )
        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Item deleted successfully'})
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'message': f'Error deleting item: {str(e)}'})
        }
