#!/bin/sh

# Navigate to lambda directory
cd lambda

# Install zip
apt update
apt install zip -y

# Package dependencies as per https://docs.aws.amazon.com/lambda/latest/dg/python-package.html#python-package-create-dependencies
mkdir package
pip3 install -r requirements.txt --target ./package
cd package
zip -r ../my_deployment_package.zip .
cd ..
zip my_deployment_package.zip lambda_function.py

# Remove the package with all dependencies
rm -rf package
