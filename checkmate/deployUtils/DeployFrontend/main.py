"""
This script deploys the built frontend to AWS Amplify.

Required external libraries:
    - boto3

Required environment variables:
    - AWS_ACCESS_KEY_ID
    - AWS_SECRET_ACCESS_KEY
    - AWS_REGION

Optional environment variables:
    - AWS_SESSION_TOKEN (default: None)
    - DEVMODE (default: None)
"""

# Import necessary libraries
import zipfile  # Used to zip the built contents
from datetime import datetime, timezone  # Used to name resources in dev mode
from os import getenv as os_getenv  # Used to retrieve environment variables
from os import path as os_path  # Used for path related operations
from os import walk as os_walk  # Used to navigate dir
from sys import exit  # Used to exit if environment variables empty
from time import sleep  # Used to wait for build to complete

import boto3  # AWS SDK for Python to interact with AWS services
import requests

# Retrieve AWS credentials and session token from environment variables
aws_access_key_id = os_getenv('AWS_ACCESS_KEY_ID')  # AWS Access Key ID
aws_secret_access_key = os_getenv(
    'AWS_SECRET_ACCESS_KEY')  # AWS Secret Access Key
aws_region = os_getenv('AWS_REGION')  # AWS region
aws_session_token = os_getenv('AWS_SESSION_TOKEN')  # Optional session token

# Flag to indicate dev mode (SET = dev mode)
dev_mode = os_getenv('DEVMODE')

if not all([aws_access_key_id, aws_secret_access_key, aws_region]):
    print('Required environment variable is empty. Aborting!')
    exit(1)


def zip_directory(folder_path, output_zip):
    # Zips the contents of a path to `output_zip`
    with zipfile.ZipFile(output_zip, 'w', zipfile.ZIP_DEFLATED) as zipf:
        for root, _, files in os_walk(folder_path):
            for file in files:
                file_path = os_path.join(root, file)
                zipf.write(file_path, os_path.relpath(file_path, folder_path))


# Directory containing built frontend
built_app_dir = 'dist'
# Name of zip file to upload to Amplify
zip_file_path = 'dist.zip'

# Wait for build to finish
while not os_path.exists(os_path.join(built_app_dir, 'index.html')):
    print('Waiting for build to finish')
    sleep(5)

# Zip the deployment after build is finished
print('Build finished! Zipping...')
zip_directory(built_app_dir, zip_file_path)

# Create an Amplify client
amplify_client = boto3.client(
    'amplify',
    aws_access_key_id=aws_access_key_id,
    aws_secret_access_key=aws_secret_access_key,
    aws_session_token=aws_session_token,
    region_name=aws_region,
)

# Create an app
response_create_app = amplify_client.create_app(
    name=f'checkmate-frontend-{
        datetime.now(timezone.utc)
        .strftime("%Y%m%d%H%M%S") if dev_mode else "prod"}',
    # Rewrite rules similar to nginx try_files to support
    # client-side routing
    customRules=[
        {
            'source': '/<*>',
            'target': '/index.html',
            'status': '404-200',
        },
    ],
)

# Obtain app ID from response
amplify_app_id = response_create_app['app']['appId']
amplify_branch_name = 'dev' if dev_mode else 'prod'

# Create a branch
amplify_client.create_branch(
    appId=amplify_app_id,
    branchName=amplify_branch_name,
    stage='PRODUCTION'
)

# Create a deployment
response_create_deployment = amplify_client.create_deployment(
    appId=amplify_app_id,
    branchName=amplify_branch_name,
)

# Obtain job id from response
amplify_deployment_job_id = response_create_deployment['jobId']

# Obtain zip upload URL from response
zip_upload_url = response_create_deployment['zipUploadUrl']

# Upload zip using requests
with open(zip_file_path, 'rb') as file_data:
    requests.put(zip_upload_url, data=file_data)

# Start the deployment
amplify_client.start_deployment(
    appId=amplify_app_id,
    branchName=amplify_branch_name,
    jobId=amplify_deployment_job_id
)
