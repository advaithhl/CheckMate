import bcrypt
import boto3


def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('users')

    try:
        name = event['name']
        username = event['username']
        password = event['password']

        # Hash the password for security
        hashed_password = bcrypt.hashpw(
            password.encode('utf-8'), bcrypt.gensalt())

        # Check if username already exists
        response = table.get_item(Key={'username': username})
        if 'Item' in response:
            return {
                'statusCode': 409,
                'body': 'Username already exists'
            }

        # Put the user data into DynamoDB
        response = table.put_item(
            Item={
                'name': name,
                'username': username,
                'hashedPassword': hashed_password.decode('utf-8')
            }
        )

        return {
            'statusCode': 201,
            'body': 'User registered successfully'
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': f'An error occurred: {str(e)}'
        }
