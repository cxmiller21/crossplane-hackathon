#!/bin/bash

AWS_S3_BUCKET_NAME = "crossplane-bucket-abc123"

echo "Creating AWS S3 bucket"
kubectl create -f ./manifests/project/s3-bucket.yaml
kubectl wait --for=condition=Ready --timeout=180s bucket $AWS_S3_BUCKET_NAME

echo "Zipping and uploading lambda function code to S3 bucket"
./scripts/zip-and-upload-lambda-code.sh

echo "Creating AWS IAM role and policies"
kubectl create -f ./manifests/project/lambda-iam-permissions.yaml
kubectl wait --for=condition=Ready --timeout=180s role.iam crossplane-lambda-role
kubectl wait --for=condition=Ready --timeout=180s policy.iam hackathon-lambda-policy
kubectl wait --for=condition=Ready --timeout=180s rolepolicyattachment lambda-iam-permissions

echo "Creating AWS Lambda function"
kubectl create -f ./manifests/project/lambda-function.yaml
kubectl wait --for=condition=Ready --timeout=180s function.lambda.aws.upbound.io crossplane-slack-function
