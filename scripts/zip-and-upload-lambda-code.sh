#!/bin/bash

# Please update these variables before running the script
AWS_CLI_PROFILE="default"
AWS_S3_BUCKET_NAME="crossplane-bucket-"

ZIP_FILE_NAME="crossplane-slack-function.zip"

echo "Zipping local lambda function"
zip $ZIP_FILE_NAME ./lambda_function.py

echo "Uploading zip file: ${ZIP_FILE_NAME} to S3 bucket: ${AWS_S3_BUCKET_NAME}"
aws s3 cp ./$ZIP_FILE_NAME s3://$AWS_S3_BUCKET_NAME/ --profile $AWS_CLI_PROFILE
