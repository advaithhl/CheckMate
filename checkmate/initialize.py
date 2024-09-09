"""
This script initializes the AWS S3 remote backend for terraform.
The state is stored in S3 and DynamoDB is used to lock the statefile.

Required external libraries:
    - boto3

Required environment variables:
    - AWS_ACCESS_KEY_ID
    - AWS_SECRET_ACCESS_KEY

Optional environment variables:
    - AWS_SESSION_TOKEN
"""

# Import necessary libraries
# Attempt to import the os library's 'getenv' method and the boto3 library.
# If the module is not found, a ModuleNotFoundError is raised and caught.
try:
    from os import \
        getenv as os_getenv  # Used to retrieve environment variables

    import boto3  # AWS SDK for Python to interact with AWS services
except ModuleNotFoundError as mnfe:
    # If either of the modules cannot be imported, an error message is printed.
    print('Required module not found:', mnfe)
else:
    # Retrieve AWS credentials and session token from environment variables
    aws_access_key_id = os_getenv('AWS_ACCESS_KEY_ID')  # AWS Access Key ID
    aws_secret_access_key = os_getenv(
        'AWS_SECRET_ACCESS_KEY')  # AWS Secret Access Key
    aws_session_token = os_getenv('AWS_SESSION_TOKEN') if os_getenv(
        'AWS_SESSION_TOKEN') else None  # Optional session token
    # Specify the AWS region
    aws_region = 'ap-south-1'

    # Define the S3 bucket name and DynamoDB table name
    # S3 bucket for storing Terraform state
    s3_bucket_name = 'checkmate-tfstate-test'
    # DynamoDB table name for locking Terraform state
    dydb_table_name = 'checkmate-tf-test'

    # Initialize an S3 client using the provided credentials and region
    s3_client = boto3.client(
        's3',
        aws_access_key_id=aws_access_key_id,
        aws_secret_access_key=aws_secret_access_key,
        aws_session_token=aws_session_token,
        region_name=aws_region,
    )

    # Initialize a DynamoDB client using the provided credentials and region
    dydb_client = boto3.client(
        'dynamodb',
        aws_access_key_id=aws_access_key_id,
        aws_secret_access_key=aws_secret_access_key,
        aws_session_token=aws_session_token,
        region_name=aws_region,
    )

    # Create an S3 bucket
    s3_client.create_bucket(
        Bucket=s3_bucket_name,  # Name of the S3 bucket to be created
        CreateBucketConfiguration={
            'LocationConstraint': aws_region,  # Set the region for the new bucket
        },
    )

    # Create a DynamoDB table for managing locks
    lock_table = dydb_client.create_table(
        TableName=dydb_table_name,  # Name of the DynamoDB table to be created
        KeySchema=[
            {
                # Define the partition key (primary key)
                'AttributeName': 'LockID',
                # Type of key (HASH indicates partition key)
                'KeyType': 'HASH'
            },
        ],
        AttributeDefinitions=[
            {
                # Define the attribute for the partition key
                'AttributeName': 'LockID',
                # Specify the attribute type as a string (S)
                'AttributeType': 'S'
            },
        ],
        ProvisionedThroughput={
            # Set the read capacity units for the table
            'ReadCapacityUnits': 5,
            # Set the write capacity units for the table
            'WriteCapacityUnits': 5
        },
    )
